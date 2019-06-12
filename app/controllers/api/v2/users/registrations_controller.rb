module Api
  module V2
    module Users
      # Handles the registration process
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        def create
          build_resource(sign_up_params)

          resource.save
          render_resource(resource)
        end

        private

        def sign_up_params
          params.require(:user).permit(:username, :email, :password, :phone_number)
        end
      end
    end
  end
end