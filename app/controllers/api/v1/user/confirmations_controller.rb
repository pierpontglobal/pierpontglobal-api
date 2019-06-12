# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the email confirmations
      class ConfirmationsController < Devise::ConfirmationsController
        skip_before_action :authenticate_user!

        # GET /resource/confirmation?confirmation_token=XXX
        def show
          self.resource = resource_class.confirm_by_token(params[:confirmation_token])
          yield resource if block_given?
          if resource.errors.empty?
            respond_with_navigational(resource) do
              redirect_to "#{ENV['CLIENT_TARGET']}/confirmation?result=true"
            end
          else
            respond_with_navigational(resource.errors, status: :unprocessable_entity) do
              redirect_to "#{ENV['CLIENT_TARGET']}/error?step='confirmation'"
            end
          end
        end
      end
    end
  end
end