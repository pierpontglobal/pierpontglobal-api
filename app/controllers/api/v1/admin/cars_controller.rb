require 'sidekiq/api'
require 'aws-sdk-ecs'

module Api
  module V1
    module Admin
      class CarsController < Api::V1::AdminBaseController
        def change_pulling
          state = params[:state]
          case state
          when 'start'

            ecs = Aws::ECS::Client.new
            ecs.update_service(service: "SidekiqWorkers", cluster: "PierpontGlobal", desired_count: 1)

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