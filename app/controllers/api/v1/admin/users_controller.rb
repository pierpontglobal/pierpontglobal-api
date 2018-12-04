# frozen_string_literal: true

module Api
  module V1
    module Admin

      # Allow the administrator to manage the users
      class UsersController < Api::V1::AdminBaseController

        def unblock
          user = ::User.find params[:id]
          user.reset_try_count
          render json: { status: 'success' }, status: :ok
        end

        def block; end

        def verify; end

        def revoke_verification; end

        def resolve_maxmind; end
      end
    end
  end
end
