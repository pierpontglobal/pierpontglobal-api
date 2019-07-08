
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

        def show_by
          if params[:vehicle_id].present?
            vehicle = ::HeavyVehicle.find(params[:vehicle_id])
            if vehicle.present?
              render json: {
                  vehicle: vehicle.sanitized
              }, :status => :ok
            else
              render json: {
                  message: "Couldn't find a vehicle with id: #{params[:vehicle_id]}"
              }
            end
          else
            render json: {
                message: "Please, provide a vehicle id"
            }, :status => :bad_request
          end
        end

        def query
          search_text = query_params[:search_text].present? ? query_params[:search_text] : "*"
          vehicles = ::HeavyVehicle.search search_text, page: query_params[:page], per_page: query_params[:page_size]
          render json: {
              total_vehicles: vehicles.total_count,
              vehicles: vehicles.map(&:sanitized)
          }, :status => :ok
        end

        def reindex
          ::HeavyVehicle.reindex
        end

        def query_params
          params.permit(:page, :page_size, :type, :category, :sub_category, :search_text)
        end

      end
    end
  end
end
