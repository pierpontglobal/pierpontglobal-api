# frozen_string_literal: true

module Api
  module V1
    module Admin
      # TODO: Add notifications to clients
      # Allow manipulation of the step groups
      class StepLogsController < Api::V1::AdminBaseController
        before_action :set_step_log, only: %i[show update destroy]

        def all_from_adquisition
          render json: ::StepLog.where(adquisitions: params[:adquisition_id]), status: :ok
        end

        def show
          render json: @step_log, status: :ok
        end

        def create
          @step_log = ::StepLog.create!(step_logs_params)
          render json: @step_log, status: :created
        end

        def update
          @step_log.update!(step_logs_params)
          render json: @step_log, status: :ok
        end

        def destroy
          @step_log.destroy!
        end

        private

        def set_step_log
          @step_log = ::StepLog.find(params[:id])
        end

        def step_logs_params
          params.require(:step_log).permit(:step_group_id, :description, :title, :adquisition_id)
        end
      end
    end
  end
end
