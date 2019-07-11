
module Api
  module V2
    module HeavyVehicles
      class HeavyVehiclesTypesController < ApplicationController

        def show
          limit = params[:limit] ||= 20
          page = params[:page] ||= 1
          types = ::HeavyVehicleType.limit(limit.to_i).offset(page.to_i)
          render json: {
              requested_types: types.map(&:sanitized),
              total_types: ::HeavyVehicleType.count
          }, :status => :ok
        end

      end
    end
  end
end
