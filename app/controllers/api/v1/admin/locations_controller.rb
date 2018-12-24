# frozen_string_literal: true

module Api
  module V1
    module Admin
      class LocationsController < Api::V1::AdminBaseController
        def create
          render json: Location.where(locations_parameters)
                           .first_or_create!,
                 status: :ok
        end

        def show
          render json: Location.all.sanitized, status: :ok
        end

        def destroy
          Location.find(params[:id]).destroy!
          render json: { status: 'deleted' }, status: :ok
        end

        private

        def locations_parameters
          params.require('location').permit('name', 'mh_id')
        end
      end
    end
  end
end