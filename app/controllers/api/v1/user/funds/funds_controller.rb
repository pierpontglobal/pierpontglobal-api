# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Funds
        # Handles the users related calls
        class FundsController < Api::V1::BaseController
          skip_before_action :active_user?
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

            render json: charge, status: :ok
          rescue Stripe::CardError => e
            render json: e, status: :bad_request
          end

          def show_funds
            last_record = @user.funds.last || {balance: 0}
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
            unless @user.stripe_customer
              render json: { message: 'Not associated billable identity' }, status: :ok
              return
            end
            @user_stripe = Stripe::Customer.retrieve(@user.stripe_customer)
          end
        end
      end
    end
  end
end
