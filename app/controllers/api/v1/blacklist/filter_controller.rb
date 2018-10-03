# frozen_string_literal: true

module Api
  module V1
    module Blacklist
      # Handles the users related calls
      class FilterController < Api::V1::AdminBaseController

        # Shows all created filters
        def show
          render json: Filter.all, status: :ok
        end

        # Creates a new filter
        def create
          filter = Filter.create!(
            scope: params[:scope],
            value: params[:value]
          )
          render json: filter, status: :ok
        rescue => e
          render json: { error: e }, status: :bad_request
        end

        def update
          filter = if params[:id].present?
                     Filter.find(params[:id])
                   else
                     Filter.where(scope: params[:scope], value: params[:value])
                   end
          filter.update(filter_permitted_params)
        rescue => e
          render json: { error: e }, status: :bad_request
        end

        def destroy
          filtered = Filter.where(scope: params[:scope], value: params[:value])
          filtered.first.destroy!
          render json: { status: 'successful' }, status: :ok
        rescue => e
          render json: { status: 'error', error: e.message }, status: :bad_request
        end

        private

        def filter_permitted_params; end

      end
    end
  end
end