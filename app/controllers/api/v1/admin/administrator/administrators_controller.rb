# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Administrator
        # Manages the administrators
        class AdministratorsController < Api::V1::AdminBaseController
          def show
            users = ::User.with_any_role(:super_admin, :admin)
            record_activity('Review the admin users in the platform')
            render json: users.map(&:sanitized), status: :ok
          rescue StandardError => e
            render json: e, status: :bad_request
          end

          def show_logs
            record_activity('Requested admin logs')
            render json: ActivityLog
              .all
              .offset(params[:offset] || 0)
              .limit(params[:limit] || 20)
              .order(id: :desc).map(&:sanitized),
                   status: :ok
          end

          def show_administrator_logs; end

          def upgrade; end

          def downgrade; end
        end
      end
    end
  end
end
