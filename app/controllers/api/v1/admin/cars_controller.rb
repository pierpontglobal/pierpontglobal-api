# frozen_string_literal: true

require 'sidekiq/api'
require 'aws-sdk-ecs'

module Api
  module V1
    module Admin

      # Manages the cars on our database and all processes associated to them
      class CarsController < Api::V1::AdminBaseController

        # Controls the pulling process
        def change_pulling
          state = params[:state]
          case state
          when 'start'
            start_pulling
          when 'end'
            stop_pulling
          else
            render json: { error: "There is no #{state} state, the available states are <start | end>" }, status: :bad_request
          end
        end

        private

        def stop_pulling
          Sidekiq::RetrySet.new.💣
          Sidekiq::ScheduledSet.new.💣
          render json: {"message": 'All pullings on queue cleared'}, status: :ok
        end

        def start_pulling
          PullCarsJob.perform_at(1.hour.from_now)
          sq = Sidekiq::ScheduledSet.new
          render json: {"message": 'Pulling started 💣', "on_queue": sq.count}, status: :ok
        end
      end
    end
  end
end
