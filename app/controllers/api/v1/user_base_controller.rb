# frozen_string_literal: true

require 'twilio-ruby'
require 'authy'

module Api
  module V1
    # Base controller for the version 1 of the API
    class UserBaseController < ApplicationController
      skip_before_action :authenticate_user!, only: :health

      def health
        render json: { status: 'healthy', ip: request.remote_ip.to_s },
               status: :ok
      end

      private
    end
  end
end
