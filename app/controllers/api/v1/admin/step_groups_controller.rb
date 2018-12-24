# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Allow manipulation of the step groups
      class StepGroupsController < Api::V1::AdminBaseController
        before_action :set_api_v1_admin_step_group, only: %i[show update destroy]

        def all
          render json: ::StepGroup.all, status: :ok
        end

        def show
          render json: @api_v1_admin_step_group, status: :ok
        end

        def create
          @api_v1_admin_step_group = ::StepGroup.new(api_v1_admin_step_group_params)

          if @api_v1_admin_step_group.save!
            render json: @api_v1_admin_step_group, status: :created
          else
            render json: @api_v1_admin_step_group.errors, status: :unprocessable_entity
          end
        end

        def update
          if @api_v1_admin_step_group.update(api_v1_admin_step_group_params)
            render json: @api_v1_admin_step_group, status: :ok
          else
            render json: @api_v1_admin_step_group.errors, status: :unprocessable_entity
          end
        end

        def destroy
          @api_v1_admin_step_group.destroy
        end

        private

        def set_api_v1_admin_step_group
          @api_v1_admin_step_group = ::StepGroup.find(params[:id])
        end

        def api_v1_admin_step_group_params
          params.require(:step_group).permit(:name, :step_number, :description)
        end
      end
    end
  end
end