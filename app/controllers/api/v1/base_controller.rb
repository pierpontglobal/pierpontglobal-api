# frozen_string_literal: true

require 'twilio-ruby'
require 'authy'

module Api
  module V1
    # Base controller for the version 1 of the API
    class BaseController < ApplicationController

      def twilio_client

      end

      def authy_client

      end

      private

      def check_2f
        head(403) unless @user.is_token_active
      end
    end
  end
end
