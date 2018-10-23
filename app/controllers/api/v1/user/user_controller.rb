# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the users related calls
      class UserController < Api::V1::BaseController
        skip_before_action :doorkeeper_authorize!,
                           only: %i[change_password
                                    modify_password]

        # Shows the current use information
        def me
          render json: @user.sanitized, status: :ok
        end

        def is_phone_verified?
          phone_sections = @user.phone_number.split '-'
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
            @user.phone_number_validated = false
            render(json: { err: 'Verify Token Error' },
                   status: :bad_request) && return
          end

          @user.phone_number_validated = true
          @user.save!
          render json: response, status: :ok
        end

        def set_2fa
          @user
        end

        def send_phone_verification
          phone_sections = @user.phone_number.split '-'
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
          @user.update(permitted_user_params)
          @user.verified = false
          @user.save!
          render json: @user.sanitized, status: :ok
        end

        def modify_address
          @user.update(permitted_address_params)
          @user.verified = false
          @user.save!
          render json: @user.sanitized, status: :ok
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
