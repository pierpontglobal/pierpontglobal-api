# frozen_string_literal: true

module Api
  module V1
    module Car
      # Control the bids
      class BidsController < Api::V1::BaseController
        skip_before_action :active_user? # TODO: REMOVE IN PRODUCTION

        def show
          bid_collector = BidCollector.find_by(car_id: params['car_id'])
          bids = bid_collector.bids
          user_bids = bids.find_by(user_id: @user.id)
          render json: user_bids, status: :ok
        end

        def increase_bid
          car_id = params[:car_id]
          amount = params[:amount]

          fund_object = @user.funds.last
          balance = fund_object.balance || 0
          amount_fraction = amount * 10 / 100

          if amount_fraction > (balance - fund_object.holding)
            render json: { status: 'failed',
                           message: 'The amount submitted does not correlates with your balance' },
                   status: :bad_request
            return
          end

          bid_collector = BidCollector.where(car_id: car_id).first_or_create!
          bid = Bid.create!(
            amount: params[:amount],
            user: @user,
            bid_collector: bid_collector
          )

          Fund.create!(
            payment: nil,
            balance: balance,
            amount: 0,
            credit: false,
            holding: fund_object.holding + (amount * 10 / 100),
            user: @user,
            source_id: "On going bid: #{bid_collector.id}"
          )

          render json: { status: 'success',
                         message: bid,
                         step: 'posting' }, status: :ok
        end
      end
    end
  end
end
