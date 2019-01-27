# frozen_string_literal: true

module Api
  module V1
    module Car
      # Allow the caller to administer the cars on the database
      class CarsController < Api::V1::BaseController
        skip_before_action :doorkeeper_authorize!
        skip_before_action :active_user?

        # QUERY SYSTEM

        def show
          render json: ::Car.sanitized.find_by_vin(params[:vin]).create_structure, status: :ok
        end

        def latest
          render json: ::Car.limit_search(params[:offset], params[:limit])
                            .sanitized
                            .newest,
                 status: :ok
        end

        def all
          render json: ::Car.limit_search(params[:offset], params[:limit])
                            .sanitized,
                 status: :ok
        end

        def query
          params[:limit] ||= 20
          params[:offset] ||= 0
          params[:q] ||= '*'

          selector_params = {}
          selector_params[:doors] = clean_array(params[:doors]) if params[:doors].present?
          selector_params[:car_type] = clean_array(params[:car_type]) if params[:car_type].present?
          selector_params[:maker_name] = clean_array(params[:maker]) if params[:maker].present?
          selector_params[:model_name] = clean_array(params[:model]) if params[:model].present?
          selector_params[:body_type] = clean_array(params[:body_type]) if params[:body_type].present?
          selector_params[:engine] = clean_array(params[:engine]) if params[:engine].present?
          selector_params[:fuel] = clean_array(params[:fuel]) if params[:fuel].present?
          if params[:transmission].present?
            selector_params[:transmission] = (clean_array(params[:transmission])
                                                  .map { |tr| binary_selector('automatic', tr) })
          end
          selector_params[:odometer] = clean_range(params[:odometer]) if params[:odometer].present?
          selector_params[:color] = clean_array(params[:color]) if params[:color].present?
          selector_params[:trim] = clean_array(params[:trim]) if params[:trim].present?
          selector_params[:year] = clean_array(params[:year]) if params[:year].present?

          cars = ::Car.where(year: 2018).search(params[:q],
                                                fields: [:car_search_identifiers],
                                                limit: params[:limit],
                                                offset: params[:offset],
                                                operator: 'or',
                                                scope_results: ->(r) { r.sanitized },
                                                aggs: %i[engine doors car_type maker_name model_name body_type fuel transmission odometer color trim year],
                                                where: selector_params)

          render json: { size: cars.total_count,
                         cars: cars.map(&:create_structure),
                         available_arguments: cars.aggs }, status: :ok
        end

        # CAR STATE HISTORY CONTROLLER

        def log_state_change; end

        private

        def clean_array(arr_string)
          arr_string.split(',').map { |s| s == 'null' ? nil : s }
        end

        def clean_range(arr_string)
          arr = arr_string.split(',').map { |s| s == 'null' ? nil : s.to_i }
          { gte: arr[0], lte: arr[1] }
        rescue StandardError
          { gte: 0, lte: 9_999_999 }
        end

        def binary_selector(true_value, value)
          true_value == value
        end
      end
    end
  end
end
