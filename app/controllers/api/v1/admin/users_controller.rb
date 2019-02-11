# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Allow the administrator to manage the users
      class UsersController < Api::V1::AdminBaseController

        def unblock
          user = ::User.find params[:id]
          user.unlock
          render json: { status: 'success' }, status: :ok
        end

        def block
          user = ::User.find params[:id]
          user.lock
          render json: { status: 'success' }, status: :ok
        end

        def maxmind_notice
          user = ::User.find params[:id]
          render json: { notices: risk_notice_processor(user.risk_notices.sanitize) },
                 status: :ok
        end

        def maxmind_notices
          risk_notice = RiskNotice.all.sanitize.where(status: params[:status])
          risk_hash = risk_notice_processor risk_notice
          render json: { notices: risk_hash }
        end

        # TODO: Preserve risk notices.
        def resolve_maxmind
          user = ::User.find params[:id]
          user.risk_notices
              .find(params[:risk_notice_id])
              .destroy!
          render json: { status: 'success' }, status: :ok
        rescue NoMethodError => e
          render json: { error: e }, status: :bad_request
        end

        def risk_notice_status
          user = ::User.find params[:id]
          risk_notice = user.set_risk_status(params[:risk_notice_id], params[:status])
          render json: risk_notice, status: :ok

        rescue NoMethodError => e
          render json: { error: e }, status: :bad_request
        end

        private

        def risk_notice_processor(risk_notice)
          risk_hash = []
          risk_notice.each do |rn|
            rn_js = rn.as_json.except('message')
            rn_js['message'] = JSON.parse(rn.message) unless rn.message.blank?
            risk_hash << rn_js
          end
          risk_hash
        end
      end
    end
  end
end
