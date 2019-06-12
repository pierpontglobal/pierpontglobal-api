# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Funds
        # Handles the users related calls
        class FundsController < Api::V1::UserBaseController
          before_action :stripe_user

          Stripe.api_key = ENV['STRIPE_KEY']

          def add_funds
            charge = Stripe::Charge.create(
              amount: (params[:amount] * 100).to_i,
              currency: 'usd',
              customer: @user_stripe.id,
              description: 'Funds addition payment'
            )

            if charge.status == 'succeeded'
              last_record = @user.funds.last
              last_balance = last_record ? last_record.balance : 0
              Fund.create!(
                payment: nil,
                balance: last_balance + params[:amount],
                amount: params[:amount],
                holding: last_record ? last_record.holding : 0,
                credit: true,
                user: @user,
                source_id: charge.id
              )
            end

            NotificationHandler.send_notification('New funds', "Amount: #{params[:amount]}, Last balance #{last_balance}, New balance: #{last_balance + params[:amount]}",
                                                  charge, @user[:id])

            render json: charge, status: :ok
          rescue Stripe::CardError => e
            render json: e, status: :bad_request
          end

          def show_funds
            last_record = @user.funds.try(:last) || { balance: 0 }
            render json: last_record, status: :ok
          end

          def funds_transactions
            render json: @user.funds, status: :ok
          end

          def request_refund
            # TODO: Allow the user to request a refund
          end

          private

          def stripe_user
            @user_stripe = Stripe::Customer.retrieve(@user.stripe_customer)

          rescue Stripe::APIConnectionError => e
            render json: { message: 'Connection with stripe failed', error: e }, status: :service_unavailable

          rescue StandardError => e
            render json: { message: 'Not associated billable identity', error: e }, status: :not_found
            nil # Close request
          end
        end
      end
    end
  end
end
