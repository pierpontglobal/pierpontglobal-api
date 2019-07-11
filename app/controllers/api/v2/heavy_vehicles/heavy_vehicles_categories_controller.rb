
module Api
  module V2
    module HeavyVehicles
      class HeavyVehiclesCategoriesController < ApplicationController

        def show
          limit = params[:limit] ||= 20
          page = params[:page] ||= 1
          filter_id = params[:filter_id]
          categories = ::HeavyVehicleCategory.where(:type_id => filter_id.to_i).limit(limit).offset(page)
          render json: {
              requested_categories: categories.map(&:sanitized),
              total_categories: ::HeavyVehicleCategory.count
          }, :status => :ok
        end

      end
    end
  end
end
