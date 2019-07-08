
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

        def query
          search_text = query_params[:search_text].present? ? query_params[:search_text] : "*"
          puts '>>>>>>>>>>>'
          puts search_text
          vehicles = ::HeavyVehicle.search search_text, page: query_params[:page], per_page: query_params[:page_size]
          render json: {
              total_vehicles: vehicles.total_count,
              vehicles: vehicles
          }, :status => :ok
        end

        def reindex
          ::HeavyVehicle.reindex
        end

        def query_params
          params.require(:vehicle).permit(:page, :page_size, :type, :category, :sub_category, :search_text)
        end

      end
    end
  end
end
