# frozen_string_literal: true

module Api
  module V1
    module Car
      # Allow the caller to administer the cars on the database
      class CarController < ApplicationController
        def show
          render json: Car.limit_search.sanitize.newest,
                 status: :ok
        end
      end
    end
  end
end
