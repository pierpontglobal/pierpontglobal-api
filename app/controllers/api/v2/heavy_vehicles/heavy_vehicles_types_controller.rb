
module Api
  module V2
    module HeavyVehicles
      class HeavyVehiclesTypesController < ApplicationController

        def show
          limit = params[:limit] ||= 20
          types = ::HeavyVehicleType.limit(limit)
          render json: {
              requested_types: types.map(&:sanitized),
              total_types: ::HeavyVehicleType.count
          }, :status => :ok
        end

      end
    end
  end
end
