# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Dealers
        # Handles the users related calls
        class DealersController < Api::V1::UserBaseController

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
              user: current_user
            )

            NotificationHandler.send_notification('Welcome to Pierpont Global',
      "#{current_user[:first_name]} #{current_user[:last_name]}, We are pleased that you have made the decision to be part of us. We are committed to growing your business through this platform. Thanks and any inconvenience, do not hesitate to contact us.",
              dealer, current_user[:id])


            render json: dealer, status: :created
          end

          def update_dealer
            current_user.dealer.update!(params.permit(
                                   :name,
                                   :latitude,
                                   :longitude,
                                   :phone_number,
                                   :country,
                                   :city,
                                   :address1,
                                   :address2
                                 ))
            render json: current_user.dealer, status: :ok
          end

          def set_photo
            photo = params[:logo]
            if photo.present?
              p '<<<<<<<<<<<<<<<<'
              dealer = ::Dealer.find_by(:user_id => current_user[:id])
              if dealer.present?
                dealer.dealer_logo.attach(params[:logo])
                render json: dealer.sanitized, status: :ok
              else
                render json: "No dealer found with ID: #{params[:dealer_id]}", status: :not_found
              end
            else
              render json: "Please, provide a photo to set.", status: :bad_request
            end
          end

          def retrieve_dealer
            render json: Dealer.find_by(user: current_user), status: :ok
          end
        end
      end
    end
  end
end
