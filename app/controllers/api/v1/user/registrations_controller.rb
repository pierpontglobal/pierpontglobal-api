# frozen_string_literal: true

require 'minfraud'
require 'stripe'

module Api
  module V1
    module User
      # Handles the registration process
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :doorkeeper_authorize!, only: :create

        Stripe.api_key = ENV['STRIPE_KEY']

        # POST /resource
        def create
          # Warning collector
          @data = {
            warnings: [],
            errors: []
          }
          @status = :ok

          # Permitted parameters to be received from the request
          limit_parameters

          ######################################################################
          # USER REGISTRATION FILTERS :START
          ######################################################################
          #
          # The user has to pass the following filters to be allowed to use the
          # application.
          #
          ######################################################################

          # 1) Maxmind report | The risk limit is 20, after the limit the user
          # will be allowed to create the account but the administrator have to
          # review it for activation.

          # 2) The user has to pass the manually added filters from the
          # administrator to use the application.

          if local_blacklisted
            # TODO: Send alert to administrator
            render json: { error: 'User has been blacklisted, contact support' },
                   status: :bad_request
            return
          end
          risk_score = maxmind_report.body.risk_score
          if risk_score > 20
            # TODO: Send alert to administrator
            @data[:warnings] << { source: 'maxmind_validation',
                                  message: ::TEXT_RESPONSE[:high_risk] }
            @maxmind_notice = RiskNotice.create!(
              maxmind_risk: risk_score,
              status: 'pending',
              message: maxmind_report.body.to_json.html_safe
            )
          end

          ######################################################################
          # USER REGISTRATION FILTERS :END
          ######################################################################

          if user_present
            @data[:errors] << { source: 'user_presence', message: 'User already exist' }
            @status = :bad_request
          else
            build_resource(@sign_up_params)
            update_risk_notice

            stripe_customer = Stripe::Customer.create(
                email: @sign_up_params[:email],
                description: "Customer for #{@sign_up_params[:email]}"
            )
            resource.stripe_customer = stripe_customer.id
            Stripe::Subscription.create(
              customer: stripe_customer.id,
              billing: 'send_invoice',
              days_until_due: 30,
              items: [
                {
                  plan: 'plan_ELmsSxYxjI36gE'
                }
              ]
            )

            if params['2fa']
              ##################################################################
              # USER PHONE VERIFICATION :START
              ##################################################################

              resource.require_2fa = true
              unless send_phone_verification resource
                data[:warnings] << { source: 'phone_verification', message: 'Couldn\'t send phone verification' }
              end

              ##################################################################
              # USER PHONE VERIFICATION :END
              ##################################################################
            else
              resource.require_2fa = false
            end

            resource.save
            if resource.persisted?
              unless resource.active_for_authentication?
                expire_data_after_sign_in!
                render json: resource.sanitized.merge(data: @data)
              end
            else
              clean_up_passwords resource
              set_minimum_password_length
              render json: resource.sanitized.merge(data: @data)
            end
            return
          end

          render json: { data: @data }, status: @status
        end

        private

        def send_phone_verification(resource)
          Confirmations.send_confirmation_to resource
        end

        def register_authy(phone_number)
          phone_sections = phone_number.split '-'
          country_code = phone_sections[0]
          phone_number = phone_sections[1]

          Authy::API.register_user(
            email: resource.email,
            cellphone: phone_number,
            country_code: country_code
          )
        end

        def limit_parameters
          @permitted_params = params.permit(
            :email,
            :password,
            :username,
            :phone_number,
            :first_name,
            :last_name,
            address: %i[
              country
              city
              zip_code
              primary_address
              secondary_address
            ]
          )
          @sign_up_params = flatten_params(@permitted_params)
        end

        def update_risk_notice
          return unless @maxmind_notice.present?
          @maxmind_notice.user = resource
          @maxmind_notice.save!
        end

        def flatten_params(param, extracted = {})
          param.each do |key, value|
            if value.is_a? ActionController::Parameters
              flatten_params(value, extracted)
            else
              extracted.merge!("#{key}": value)
            end
          end
          extracted
        end

        def user_present
          user = ::User.find_by(username: params[:username])
          user ||= ::User.find_by(email: params[:email])
          user.present?
        end

        def local_blacklisted
          # Check if email is permitted
          return true unless Filter.all.where(scope: 1, value: params[:email]).empty?
          # Check if username is permitted
          return true unless Filter.all.where(scope: 2, value: params[:username]).empty?
          # Check if phone number ins permitted
          return true unless Filter.all.where(scope: 3, value: params[:phone_number]).empty?
          false
        end

        def maxmind_report
          # TODO: [IMPORTANT]* Get the real user ip address for the Minfraud verification #tree
          device = Minfraud::Components::Device.new(ip_address: '152.0.182.55')
          email = Minfraud::Components::Email.new(
            address: params[:email],
            domain: params[:email].split('@').last
          )

          account = Minfraud::Components::Account.new(
            user_id: params[:username]
          )

          if params[:address].present?
            billing = Minfraud::Components::Billing.new(
              first_name: params[:first_name],
              last_name: params[:last_name],
              address: params[:address][:primary_address],
              address_2: params[:address][:secondary_address],
              country: params[:address][:country],
              city: params[:address][:city],
              postal: params[:address][:zip_code],
              phone_number: params[:phone_number]
            )

            shipping = Minfraud::Components::Shipping.new(
              first_name: params[:first_name],
              last_name: params[:last_name],
              address: params[:address][:primary_address],
              address_2: params[:address][:secondary_address],
              country: params[:address][:country],
              city: params[:address][:city],
              postal: params[:address][:zip_code],
              phone_number: params[:phone_number]
            )

            assessment = Minfraud::Assessments.new(
              device: device,
              email: email,
              account: account,
              billing: billing,
              shipping: shipping
            )
          else
            assessment = Minfraud::Assessments.new(
              device: device,
              email: email,
              account: account
            )
          end
          assessment.insights
        end
      end
    end
  end
end
