# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the registration process
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :doorkeeper_authorize!, only: :create
        # before_action :configure_sign_up_params, only: [:create]
        # before_action :configure_account_update_params, only: [:update]

        # GET /resource/sign_up
        # def new
        #   super
        # end

        # POST /resource
        def create
          sign_up_params = params.permit(
            :email,
            :password,
            :username,
            :phone_number,
            :first_name,
            :last_name,
            :city,
            :street_address,
            :phone_number
          )
          if user_present
            render json: { error: 'Username already exist' },
                   status: :bad_request
          else
            build_resource(sign_up_params)
            resource.save
            if resource.persisted?
              unless resource.active_for_authentication?
                expire_data_after_sign_in!
                render json: resource
              end
            else
              clean_up_passwords resource
              set_minimum_password_length
              respond_with resource
            end
          end
        end

        # GET /resource/edit
        # def edit
        #   super
        # end

        # PUT /resource
        # def update
        #   super
        # end

        # DELETE /resource
        # def destroy
        #   super
        # end

        # GET /resource/cancel
        # Forces the session data which is usually expired after sign
        # in to be expired now. This is useful if the user wants to
        # cancel oauth signing in/up in the middle of the process,
        # removing all OAuth session data.
        # def cancel
        #   super
        # end

        # protected

        # If you have extra params to permit, append them to the sanitizer.
        # def configure_sign_up_params
        #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
        # end

        # If you have extra params to permit, append them to the sanitizer.
        # def configure_account_update_params
        #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
        # end

        # The path used after sign up.
        # def after_sign_up_path_for(resource)
        #   super(resource)
        # end

        # The path used after sign up for inactive accounts.
        # def after_inactive_sign_up_path_for(resource)
        #   super(resource)
        # end

        private

        def user_present
          user = ::User.find_by(username: params[:username])
          user.present?
        end
      end
    end
  end
end
