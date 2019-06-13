# frozen_string_literal: true

module Api
  module V1
    module Admin
      class TransactionsController < Api::V1::AdminBaseController

        # TODO: Enhance transaction management
        def create_transaction
          user = ::User.find(params[:user_id])
          payment = Payment.create!(
            user: user,
            amount: params[:amount],
            payment_note: params[:note],
            verified_by_id: current_user.id
          )
          render json: payment, status: :ok
        end

        def remove_transaction
          charge = Payment.find(params[:charge_id])
          counter_charge = Payment.create!(
            user: charge.user,
            amount: (-1 * charge.amount),
            payment_note: params[:note],
            verified_by_id: current_user.id
          )
          render json: counter_charge, status: :ok
        end

        def attach_file
          # TODO: Allow the admin to attach files
        end
      end
    end
  end
end
