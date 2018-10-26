# frozen_string_literal: true

module Api
  module V1
    # Base controller for the version 1 of the API
    class AdminBaseController < ApplicationController
      before_action :admin_oauth

      private

      def admin_oauth
        unless @user.has_role? :admin
          render json: { status: 'failed', reason: 'You are not an admin user' }, status: :unauthorized
          return
        end
      end
    end
  end
end