# frozen_string_literal: true

require 'stripe'

module Api
  module V1
    module User
      module Cards
        # Handles the users related calls
        class CardsController < Api::V1::BaseController
          skip_before_action :active_user?

          Stripe.api_key = ENV['STRIPE_KEY']

          def card_registration
            if @user.stripe_customer
              customer = Stripe::Customer.retrieve(@user.stripe_customer)
              customer.sources.create(source: params['card_token'])
            else
              customer = Stripe::Customer.create(
                source: params['card_token'],
                email: @user.email
              )
              @user.update!(stripe_customer: customer.id)
            end
            render json: { status: 'created' }, status: :created
          end

          def card_sources
            if @user.stripe_customer
              customer = Stripe::Customer.retrieve(@user.stripe_customer)
              sources = customer.sources.data
              card_sources = []
              sources.each do |source|
                card_sources << source if source.object == 'card'
              end
              render json: card_sources, status: :ok
            else
              render json: { message: 'No cards registered' }, status: :ok
            end
          end

          def change_default_card_source
            if @user.stripe_customer
              customer = Stripe::Customer.retrieve(@user.stripe_customer)
              customer.default_source = params['card_id']
              customer.save
              render json: customer.default_source, status: :ok
            else
              render json: { message: 'No cards registered' }, status: :ok
            end
          end

          def default_card_source
            if @user.stripe_customer
              customer = Stripe::Customer.retrieve(@user.stripe_customer)
              render json: customer.default_source, status: :ok
            else
              render json: { message: 'No cards registered' }, status: :ok
            end
          end

          def remove_card
            if @user.stripe_customer
              customer = Stripe::Customer.retrieve(@user.stripe_customer)
              render json: customer.sources.retrieve(params['card_id']).delete, status: :ok
            else
              render json: { message: 'No cards registered' }, status: :ok
            end
          end
        end
      end
    end
  end
end
