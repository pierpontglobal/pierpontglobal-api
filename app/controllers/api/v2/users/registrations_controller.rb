require 'stripe'

module Api
  module V2
    module Users
      # Handles the registration process
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        Stripe.api_key = ENV['STRIPE_KEY']

        def create
          stripe_customer = Stripe::Customer.create({
                                      description: `Customer for #{params[:user][:email]}`,
                                      source: params[:user][:source][:id],
                                      name: params[:user][:first_name],
                                      email: params[:user][:email]
                                  })

          subscription = Stripe::Subscription.create({
                                          customer: stripe_customer.id,
                                          items: [
                                              {
                                                  plan: 'PG_USA_ACCESS',
                                              },
                                          ],
                                          coupon: params['coupon'] || ''
                                      })

          if subscription.status == 'active'
            build_resource(sign_up_params)
            resource.stripe_customer = stripe_customer.id
            resource.confirmed_at = Time.now
            resource.save!
            dealer = Dealer.new(dealer_params)
            dealer.user = resource
            dealer.save!
            resource.dealer = dealer

            NotificationHandler.send_notification('Welcome to Pierpont Global',
                                                  "#{resource[:first_name]} , We are pleased that you have made the decision to be part of us. We are committed to growing your business through this platform. Thanks and any inconvenience, do not hesitate to contact us.",
                                                  dealer, resource[:id])

            render_resource(resource)
          else
            render json: {status: 'fail', message: 'Subscription couldn\'t be processed' }, status: :bad_request
          end

        rescue StandardError => e
          render json: {status: 'error', message: e.message}, status: :bad_request
        end

        private

        def sign_up_params
          params.require(:user).permit(:first_name, :email, :password, :phone_number)
        end

        def dealer_params
          params.require(:dealer).permit(:name, :country, :city, :address1)
        end
      end
    end
  end
end