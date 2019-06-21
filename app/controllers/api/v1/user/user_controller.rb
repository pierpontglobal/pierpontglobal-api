# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      # Handles the users related calls
      class UserController < Api::V1::UserBaseController
        skip_before_action :authenticate_user!,
                           only: %i[change_password
                                    modify_password
                                    subscribe
                                    verify_availability
                                    return_subscribed_info
                                    send_payment_statu
                                    resend_confirmation
                                    send_contact_form
                                    verify_user]

        Stripe.api_key = ENV['STRIPE_KEY']

        def saved_cars
          #cars = ::Car.includes(:users).where('users.id' => current_user[:id]).map(&:sanitized)
          cars = ::Car.sanitized.joins(:user_saved_cars).where('cars.id = user_saved_cars.car_id')
          render json: { cars: cars }, :status => :ok
        end

        def set_profile_photo
          photo = params[:photo]
          if photo.present?
            if current_user.profile_picture.attached?
              current_user.profile_picture.purge
            end
            current_user.profile_picture.attach(photo)
            render json: current_user.sanitized, status: :ok
          else
            render json: "Please, provide a photo to set.", status: :bad_request
          end
        end

        def settings

          if current_user.stripe_customer.present?
            customer = Stripe::Customer.retrieve(current_user.stripe_customer)
            sources = customer.sources.data
            card_sources = []
            sources.each do |source|
              card_sources << source if source.object == 'card'
            end


            subscription = customer.subscriptions.data.first
            product = Stripe::Product.retrieve(subscription.plan.product)
            subscription_details =  {
                id: subscription.id,
                billing_type: subscription.billing,
                cancelled_at: subscription.canceled_at,
                last_billing: Time.at(subscription.billing_cycle_anchor),
                days_until_due: Time.at(subscription.days_until_due || 0),
                created_at: Time.at(subscription.created),
                current_period_end: Time.at(subscription.current_period_end),
                current_period_start: Time.at(subscription.current_period_start),
                plan_name: product.name,
                plan_id: subscription.plan.id,
                amount: subscription.plan.amount,
                interval: subscription.plan.interval,
                active: subscription.plan.active,
                paid: (customer.invoices(paid: false).data.size < 1)
            }

            render json: {
                user: current_user.sanitized,
                dealer: current_user.dealer,
                card_sources: card_sources,
                subcripcion_details: subscription_details
            }, status: :ok
          else
            render json: {
                user: current_user.sanitized,
                dealer: current_user.dealer,
                card_sources: nil,
                subcripcion_details: nil
            }, status: :ok
          end

        end

        # Shows the current use information
        def info
          puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
          puts @user.inspect
          render json: current_user.sanitized, status: :ok
        end

        def resend_confirmation
          user = SubscribedUser.find_by(email: params[:email])
          user.send_confirmation
          render json: { status: 'Sent' }, status: :ok
        end

        def return_subscribed_info
          token = params[:token]
          render json: SubscribedUser.find_by_token(token), status: :ok
        end

        def verify_user
          user = SubscribedUser.where(token: params['token'], verified_on: nil).first
          if user.present?
            user.update!(verified_on: Time.now)
            ActionCable.server.broadcast("verification_channel_#{user.email}", {verified: true})
            render json: {verified: true}, status: :ok
          else
            render json: {verified: false}, status: :ok
          end
        end

        def subscribe
          user = SubscribedUser.create!(
            first_name: params[:first_name],
            last_name: params[:last_name],
            email: params[:email],
            phone_number: params[:phone_number]
          )

          render json: { status: 'Created' }, status: :created
        end

        def deregister_notifier
          Subscriber.find_by!(one_signal_uuid: params[:one_signal_uuid]).destroy! if params[:one_signal_uuid].present?
        rescue StandardError
          puts "Subscriber does not exist #{params[:one_signal_uuid]}"
        end

        def register_notifier
          Subscriber.create!(
            user: current_user,
            one_signal_uuid: params[:one_signal_uuid]
          )
          render json: {status: 'success', message: 'Added successfully'}, status: :ok
        rescue StandardError
          deregister_notifier
          register_notifier
        end

        def log_out
          current_user.invalidate_session!
          deregister_notifier
          render json: { status: 'Invalidated' }, status: :ok
        end

        def verify_availability
          render json: { available: ::User.where(email: params[:email]).size <= 0 }, status: :ok
        end

        def phone_verified?
          phone_sections = current_user.phone_number.split '-'
          country_code = phone_sections[0]
          phone_number = phone_sections[1]
          token = params[:token]

          if !phone_number || !country_code || !token
            render(json: { err: 'Missing fields' },
                   status: :bad_request) && return
          end

          response = Authy::PhoneVerification.check(
            verification_code: token,
            country_code: country_code,
            phone_number: phone_number
          )

          unless response.ok?
            current_user.phone_number_validated = false
            render(json: { err: 'Verify Token Error' },
                   status: :bad_request) && return
          end

          current_user.phone_number_validated = true
          current_user.save!
          render json: response, status: :ok
        end

        def set_two_factor_authentication
          current_user.require_2fa = true
          current_user.save!
          render json: current_user, status: :ok
        end

        def send_phone_verification
          phone_sections = current_user.phone_number.split '-'
          country_code = phone_sections[0]
          phone_number = phone_sections[1]
          via = params[:via]

          if !phone_number || !country_code || !via
            render(json: { err: 'Missing fields', phone_sections: phone_sections },
                   status: :bad_request) && return
          end

          response = Authy::PhoneVerification.start(
            via: via,
            country_code: country_code,
            phone_number: phone_number
          )

          unless response.ok?
            render(json: { err: 'Error delivering code verification' },
                   status: :bad_request) && return
          end

          render json: response, status: :ok
        end

        def modify_user
          current_user.update(permitted_user_params)
          current_user.verified = false
          current_user.save!
          render json: current_user.sanitized, status: :ok
        end

        def modify_address
          current_user.update(permitted_address_params)
          current_user.verified = false
          current_user.save!
          render json: current_user.sanitized, status: :ok
        end

        def change_password
          user = ::User.find_by(email: params[:email])
          if user
            token = generate_secure_token
            user.reset_password_token = token
            user.reset_password_sent_at = DateTime.now
            user.save!
            ::Mailers::MailerDevise.new.password_change(
              user.email,
              token,
              params[:callback]
            )
            render json: { status: 'sent' }, status: :ok
          else
            render json: { status: 'failed' }, status: :ok
          end
        end

        def send_contact_form
          email = ::Mailers::MailerDevise.new.contact_message(
              params[:email],
              params[:phone],
              params[:name],
              params[:company],
              params[:message]
          )
          email.inspect
          render json: { status: 'sent', email: email }, status: :ok
        end

        def modify_password
          user = ::User.find_by(
            email: params[:email],
            reset_password_token: params[:token]
          )
          if user
            user.reset_password_token = nil
            user.password = params['password']
            user.save!
            render json: { status: 'success' }, status: :ok
          else
            render json: {
              status: 'failed',
              reason: 'Token doesn\'t map to user'
            }, status: :ok
          end
        end

        private

        def permitted_user_params
          params.require(:user).permit(
            :first_name,
            :last_name,
            :phone_number
          )
        end

        def permitted_address_params
          params.require(:address).permit(
            :country,
            :city,
            :primary_address,
            :secondary_address,
            :zip_code
          )
        end

        protected

        def generate_secure_token
          SecureRandom.base58(48)
        end
      end
    end
  end
end
