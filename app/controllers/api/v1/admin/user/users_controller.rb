# frozen_string_literal: true

module Api
  module V1
    module Admin
      module User
        # Manages the bid process from the administrator perspective
        class UsersController < Api::V1::AdminBaseController
          before_action :set_target_user, only: [:show]

          def show_all
            if params[:starred].present?
              render json: ::User.all.where(starred: true).offset(params[:offset] || 0)
                .limit(params[:limit] || 20)
                .order(created_at: :desc)
                                 .map(&:sanitized_for_admin), status: :ok
            else
              render json: ::User.all.offset(params[:offset] || 0)
                .limit(params[:limit] || 20)
                .order(created_at: :desc)
                                 .map(&:sanitized_for_admin), status: :ok
            end
          end

          def show
            render json: @target_user.sanitized_for_admin, status: :ok
          end

          def create
            # TODO: Custom create a user
          end

          def send_email
            set_client
            users = ::User.find(params[:ids])
            template_id = params[:template_id]
            users.each do |user|
              template = load_email(user, nil, template_id)
              data = JSON.parse(template.to_json)
              @sg.client.mail._('send').post(request_body: data)
            end
          end

          private

          def load_email(user, data, template_id)
            { personalizations: [
              {
                to: [email: user.email],
                dynamic_template_data: data
              }
            ], from: { email: ENV['SOURCE_EMAIL'], name: 'PierpontGlobal' },
              template_id: template_id }
          end

          def set_target_user
            @target_user = ::User.find(params[:user_id])
          end

          def set_client
            @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
          end
        end
      end
    end
  end
end
