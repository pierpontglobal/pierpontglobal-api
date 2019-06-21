# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Bid
        # Manages the bid process from the administrator perspective
        class BidController < Api::V1::AdminBaseController
          before_action :set_bid, except: %w[show_bids bid_collector bid_details]

          # GET: /collectors
          def bid_collector
            render json: ::BidCollector
              .with_auction_date
              .where("auction_start_date > '#{DateTime.now}'")
              .limit(params[:limit])
              .offset(params[:offset])
              .map(&:create_structure)
          rescue StandardError => e
            render json: e, status: :bad_request
          end

          # GET: /collectors/:bid_collector_id
          def bid_details
            bid_collector = ::BidCollector
                            .with_auction_date
                            .find(params[:bid_collector_id])
                            .create_structure
            render json: bid_collector, status: :ok
          rescue StandardError => e
            render json: e, status: :not_found
          end

          # GET: /all
          def show_bids
            priority = params[:filter]
            case priority
            when 'NOT_SUBMITTED'
              render json: ::Bid.where(submitted: nil)
                .limit(params[:limit])
                .offset(params[:offset])
                                .map(&:create_structure), status: :ok
            when 'SUBMITTED'
              render json: ::Bid.where(submitted: true)
                .limit(params[:limit])
                .offset(params[:offset])
                                .map(&:create_structure), status: :ok
            else
              render json: ::Bid.all
                .limit(params[:limit])
                .offset(params[:offset])
                                .map(&:create_structure), status: :ok
            end

            record_activity("Reviewing bids with flag: #{priority}")
          rescue StandardError => e
            render json: { error: e }, status: :bad_request
          end

          # GET: /
          def show_bid
            record_activity("Reviewing bid with ID: #{@bid.id}")
            render json: @bid.create_structure, status: :ok
          rescue StandardError => e
            render json: { error: e }, status: :bad_request
          end

          # PATCH: /
          def change_bid_status
            record_activity("Changing bid with ID: #{@bid.id}")
            render json: { success: @bid.update!(status: params[:status]) }, status: :ok
          rescue StandardError => e
            render json: { error: e }, status: :bad_request
          end

          # DELETE: /
          def delete_bid
            if @bid.success == false
              render json: { error: 'Already removed bid' }, status: :bad_request
              record_activity("Intent of removing bid with ID: #{@bid.id}")
              return
            end

            user = @bid.user
            @bid.update!(
              success: false,
              status: 'This bid has been deactivated by the administrator, if you have any question regarding the deactivation of your bid contact support.'
            )

            bid_representation = (@bid.amount * 0.10)
            funds_status = user.funds.last
            holdings = funds_status.holding
            post_removal_holdings = holdings - bid_representation

            fund_retrieval = Fund.create!(
              payment: nil,
              balance: funds_status.balance,
              amount: 0,
              credit: true,
              user: user,
              holding: post_removal_holdings,
              source_id: "Retrieved from failed bid: #{@bid.id}"
            )

            record_activity("Removing bid with ID: #{@bid.id}")

            render json: fund_retrieval, status: :ok
          rescue StandardError => e
            render json: { error: e }, status: :bad_request
          end

          # PATCH: /submitted
          def flag_submitted
            record_activity("Flagging (#{params[:submitted]}) bid with ID: #{@bid.id}")
            render json: { success: @bid.update!(submitted: params[:submitted]) }, status: :ok
          rescue StandardError => e
            render json: { error: e }, status: :bad_request
          end

          # PATCH: /success
          def notify_success
            record_activity("Notifying (#{params[:success]}) bid with ID: #{@bid.id}")

            NotificationHandler.send_notification('Bid status', 'Bid has been placed', @bid, current_user[:id])

            render json: { success: @bid.update!(success: params[:success]) }, status: :ok
          rescue StandardError => e
            render json: { error: e }, status: :bad_request
          end

          private

          def set_bid
            bid_id = params[:id]
            @bid = ::Bid.find(bid_id)
          end
        end
      end
    end
  end
end
