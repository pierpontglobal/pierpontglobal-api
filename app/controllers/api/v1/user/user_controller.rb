# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the users related calls
      class UserController < Api::V1::BaseController
        skip_before_action :doorkeeper_authorize!, only: :change_password

        # Shows the current use information
        def me
          render json: @user.sanitized, status: :ok
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
            user.save!
            ::Mailers::MailerDevise.new.password_change(
                user.email,
                token,
                params[:callback]
            )
            render json: { status: 'sent' }, status: :ok
          end
        end

        def modify_password; end

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
