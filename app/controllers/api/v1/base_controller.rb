# frozen_string_literal: true

require 'twilio-ruby'
require 'authy'

module Api
  module V1
    # Base controller for the version 1 of the API
    class BaseController < ApplicationController
      before_action :active_user?
      skip_before_action :doorkeeper_authorize!, only: :health
      skip_before_action :current_resource_owner, only: :health
      skip_before_action :active_user?, only: :health

      def twilio_client; end

      def authy_client; end

      def health
        render json: { status: 'healthy', ip: request.remote_ip.to_s },
               status: :ok
      end

      def active_user?
        active = @user.active?
        unless active[:status]
          render json: { user: @user.sanitized, active: active },
                 status: :forbidden
        end
        return nil unless active[:status]
      end

      private

      def check_2f
        head(403) unless @user.is_token_active
      end
    end
  end
end
