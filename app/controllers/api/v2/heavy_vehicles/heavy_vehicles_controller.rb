
module Api
  module V2
    module HeavyVehicles
      class HeavyVehiclesController < ApplicationController

        def show
          worker = ::HeavyVehiclesWorker.new(1)
          render json: {
              vehicles: worker.get_vehicles
          }, :status => :ok
        end

      end
    end
  end
end
