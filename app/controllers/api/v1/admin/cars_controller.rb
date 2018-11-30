require 'sidekiq/api'
module Api
  module V1
    module Admin
      class CarsController < Api::V1::BaseController
        def change_pulling
          state = params[:state]
          case state
          when 'start'
            PullCarsJob.perform_at(1.hour.from_now)
            sq = Sidekiq::ScheduledSet.new
            render json: { "message": "Pulling started 💣", "on_queue": sq.count }, status: :ok
          when 'end'
            Sidekiq::RetrySet.new.💣
            Sidekiq::ScheduledSet.new.💣
            render json: { "message": "All pullings on queue cleared" }, status: :ok
          else
            render json: { error: "There is no #{ state } state, the available states are <start | end>" }, status: :bad_request
          end
        end
      end
    end
  end
end