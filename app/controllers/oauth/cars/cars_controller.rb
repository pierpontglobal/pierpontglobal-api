# frozen_string_literal: true

module Oauth
  module Cars
    class CarsController < OauthController
      before_action :authenticate_app

      def show
        vin = params[:vin]
        car = Car.sanitized.find_by(vin: vin)
        render json: car.create_structure, status: :ok
      end
    end
  end
end
