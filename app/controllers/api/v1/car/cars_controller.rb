# frozen_string_literal: true

module Api
  module V1
    module Car
      # Allow the caller to administer the cars on the database
      class CarsController < ApplicationController
        skip_before_action :doorkeeper_authorize!, only: :show

        def show
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

        end
      end
    end
  end
end