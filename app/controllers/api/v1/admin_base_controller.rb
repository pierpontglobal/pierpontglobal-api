# frozen_string_literal: true

module Api
  module V1
    # Base controller for the version 1 of the API
    class AdminBaseController < ApplicationController
      before_action :admin_oauth

      def record_activity(note)
        @activity = ActivityLog.new
        @activity.user = @user
        @activity.note = note
        @activity.browser = request.env['HTTP_USER_AGENT']
        @activity.ip_address = request.env['REMOTE_ADDR']
        @activity.controller = controller_name
        @activity.action = action_name
        @activity.params = params.to_json
        @activity.save
      end

      private

      def admin_oauth
        unless (@user.has_role? :admin) && (@user.has_role? :super_admin)
          render json: { status: 'failed', reason: 'You are not an admin user' }, status: :unauthorized
          nil
        end
      end
    end
  end
end
