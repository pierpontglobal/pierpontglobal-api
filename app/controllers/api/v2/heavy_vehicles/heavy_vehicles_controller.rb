
module Api
  module V2
    module HeavyVehicles
      class HeavyVehiclesController < ApplicationController

        def show
          ScrapHeavyVehicles.perform_at(1.hour.from_now)
          render json: {
              message: "Worker started!"
          }, :status => :ok
        end

      end
    end
  end
end
