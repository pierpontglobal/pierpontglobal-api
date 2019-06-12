# frozen_string_literal: true

module Api
  module V1
    module User
      module Bids
        class BidsController < Api::V1::UserBaseController

          def show
            render json: ::Bid.where(user: @user).attach_vehicle_info, status: :ok
          end

          def delete
            # bid = ::Bid.find_by(user_id: 47, id: 11)
          end
        end
      end
    end
  end
end
