# frozen_string_literal: true

module Api
  module V1
    # Base controller for the version 1 of the API
    class BaseController < ApplicationController
      def version
        render json: { version: 1 }, status: :ok
      end
    end
  end
end
