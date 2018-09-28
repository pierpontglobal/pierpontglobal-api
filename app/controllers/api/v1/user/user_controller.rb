# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the users related calls
      class UserController < Api::V1::BaseController

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

      end
    end
  end
end
