# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the users related calls
      class UserController < Api::V1::BaseController

        # Shows the current use information
        def me
          render json: @user.sanitized, status: :ok
        end
      end
    end
  end
end
