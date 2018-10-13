module Api
  module V1
    module Admin
      class CarsController < Api::V1::BaseController
        def change_pulling
          state = params[:state]
          case state
          when 'start'
            PullCarsJob.perform_at(1.hour.from_now)
            render json: { "test": "Hola" }
          when 'end'
            render json: { "test": "Hola" }
          else
            render json: { error: "There is no #{state} state, the available states are <start | end>" }, code: :ok
          end
        end
      end
    end
  end
end