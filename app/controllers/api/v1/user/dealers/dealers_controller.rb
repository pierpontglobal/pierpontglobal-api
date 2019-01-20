# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Dealers
        # Handles the users related calls
        class DealersController < Api::V1::BaseController
          skip_before_action :active_user?

          Stripe.api_key = ENV['STRIPE_KEY']
          def create_dealer
            dealer = ::Dealer.create!(
              name: params[:name],
              latitude: params[:latitude],
              longitude: params[:longitude],
              phone_number: params[:phone_number],
              country: params[:country],
              city: params[:city],
              address1: params[:address1],
              address2: params[:address2],
              user: @user
            )

            render json: dealer, status: :created
          end

          def update_dealer
            @user.dealer.update!(params.permit(
                                   :name,
                                   :latitude,
                                   :longitude,
                                   :phone_number,
                                   :country,
                                   :city,
                                   :address1,
                                   :address2
                                 ))
            render json: @user.dealer, status: :ok
          end

          def retrieve_dealer
            render json: Dealer.find_by(user: @user), status: :ok
          end
        end
      end
    end
  end
end
