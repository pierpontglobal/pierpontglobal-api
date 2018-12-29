# frozen_string_literal: true

module Api
  module V1
    module Car
      # Control the bids
      class BidsController < Api::V1::BaseController
        def increase_bid
          car_id = params[:car_id]
          amount = params[:amount]

          if get_biggest(car_id) > amount
            render json: { status: 'failed',
                           message: 'The amount submitted amount is less than the current bid' }, status: :bad_request
            return
          end

          bid_collector = BidCollector.where(car_id: params[:car_id]).first_or_create!
          Bid.create!(
            amount: params[:amount],
            user: @user,
            bid_collector: bid_collector
          )

          render json: { status: 'success',
                         message: 'Successful bid addition',
                         step: 'posting' }, status: :ok
        end

        private

        def get_biggest(car_id)
          bid_collector = BidCollector.where(car_id: car_id).first
          bigger = 0
          if bid_collector
            bid_collector.bids.each do |bid|
              (bigger = bid.amount) if bid.amount > bigger
            end
          else
            bigger = Car.find(car_id).sale_information.current_bid
          end
          bigger
        end
      end
    end
  end
end
