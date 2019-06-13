# frozen_string_literal: true

module Api
  module V1
    module Admin
      class FundsController < Api::V1::AdminBaseController

        # TODO: Enhance funds management
        def add_funds
          payment = Payment.find(params[:payment_id])
          last_record = payment.user.funds.last
          last_balance = last_record ? last_record.balance : 0
          fund = Fund.create!(
            payment: payment,
            balance: last_balance + payment.amount,
            amount: Math.abs(payment.amount),
            credit: payment.amount.positive?,
            user: payment.user,
            source_id: 'Manually applied'
          )
          record_activity("Adding #{fund.amount} to user #{payment.user} funds")

          NotificationHandler.send_notification('Added funds', 'New funds has been added', {
              payment: payment,
              fund: fund
          }, current_user[:id])

          render json: fund, status: :ok
        end

        def remove_funds
          fund = Fund.find(params[:fund_id])
          (render json: {message: 'Can\'t be removed'}; return) unless fund.credit
          counter = Fund.create!(
            payment: nil,
            balance: fund.balance - fund.amount,
            amount: fund.amount,
            credit: false,
            user: fund.user,
            source_id: 'Virtually generated'
          )
          record_activity("Removing #{counter.amount} to user #{fund.user} funds")

          NotificationHandler.send_notification('Removed funds', 'New funds has been removed', {
              counter: counter,
              fund: counter
          }, current_user[:id])

          render json: counter, status: :ok
        end

        def show_funds
          user = User.find(params[:user_id])
          render json: user.funds, status: :ok
        end
      end
    end
  end
end
