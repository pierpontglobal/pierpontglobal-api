# frozen_string_literal: true

module Api
  module V1
    module User
      # Handles the users related calls
      class UserController < Api::V1::BaseController

        def me
          render json: { name: @user.first_name }, status: :ok
        end

      end
    end
  end
end
