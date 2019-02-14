# frozen_string_literal: true

module Api
  module V1
    module User
      module Bids
        class BidsController < Api::V1::BaseController
        skip_before_action :active_user?

        def show
          render json: ::Bid.where(user: @user).attach_vehicle_info, status: :ok
        end

        def delete
        end
          end
      end
    end
  end
end
