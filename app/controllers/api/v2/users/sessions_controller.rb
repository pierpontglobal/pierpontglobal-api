module Api
  module V2
    module Users
      # Handles the registration process
      class SessionsController < Devise::SessionsController
        respond_to :json

        def new
          super
        end

        def create
          self.resource = warden.authenticate!(auth_options)
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          yield resource if block_given?
          respond_with resource.sanitized, location: after_sign_in_path_for(resource)
        end

        private

        def respond_with(resource, _opts = {})
          render json: resource
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end