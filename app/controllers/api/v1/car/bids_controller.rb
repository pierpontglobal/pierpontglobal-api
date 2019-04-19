# frozen_string_literal: true

module Api
  module V1
    module Car
      # Control the bids
      class BidsController < Api::V1::BaseController
        skip_before_action :active_user?
        before_action :set_car
        before_action :check_window_to_modify, except: :show
        before_action :check_amount_with_balance, except: :show
        before_action :set_bid_collector

        def show
          bids = @bid_collector.bids
          user_bids = bids.find_by(user_id: @user.id)
          throw StandardError if user_bids.blank?
          render json: user_bids, status: :ok
        rescue StandardError => _e
          render json: { message: 'No bids' }, status: :not_found
        end

        def deactivate_bid
          bid_id = params[:bid_id]
          user_bid = @user.bids.find(bid_id)
          remove_bid(user_bid)
        end

        def modify_bid
          bid_id = params[:bid_id]
          amount = params[:amount]
          user_bid = @user.bids.find(bid_id)

          remove_bid(user_bid)
          add_bid(amount)
        end

        def increase_bid
          amount = params[:amount]
          bid = add_bid(amount)

          NotificationHandler.send_notification('Increase bid', 'Bid has been increased', bid, current_user[:id])

          render json: { status: 'success',
                         message: bid,
                         step: 'posting' }, status: :ok
        end

        private

        def set_bid_collector
          @bid_collector = BidCollector.where(car: @car).first_or_create!
        end

        def close_proposal_with(message)
          render json: { status: 'closed',
                         message: message },
                 status: :bad_request
          nil
        end

        def check_amount_with_balance
          amount_to_bid = params[:amount]
          amount_fraction = amount_to_bid * 0.1 # 10% of the amount
          user_fund = @user.fund

          fail_message = 'The amount submitted does not correlates with your balance'
          close_proposal_with(fail_message) if amount_fraction > user_fund.available
        end

        def check_window_to_modify
          current_time = Time.now
          bid_end_time = @car.sale_information.auction_start_date
          bid_modification_closing_time = bid_end_time - 1.hour

          fail_message = 'Passed time to modify'
          close_proposal_with(fail_message) if current_time > bid_modification_closing_time
        end

        def set_car
          @car = ::Car.find(params[:car_id]) if params[:car_id]
          @car = @user.bids.find(params[:bid_id]).bid_collector.car if params[:bid_id]
        rescue StandardError => _e
          fail_message = 'Could not get the requested car or bid information'
          close_proposal_with(fail_message)
        end

        def remove_bid(bid)
          user_fund = @user.fund
          user_fund.release_from_bid(bid)
        end

        def add_bid(amount)
          Bid.create!(
            amount: amount,
            user: @user,
            status: 'active',
            bid_collector: @bid_collector
          )
        end
      end
    end
  end
end
