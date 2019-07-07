
module Api
  module V2
    module Users
      class RecoverController < ApplicationController
        skip_before_action :authenticate_user!

        def send_recover_email
          login = params[:login]
          user = ::User.where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
          if user
            render json: user.send_reset_email, status: :ok
          else
            render json: {status: :failed, message: :user_does_not_exist}, status: :bad_request
          end
        rescue NoMethodError => e
          render json: {status: :failed, message: :send_credentials, error: e}, status: :bad_request
        end

        def reset_password
          token = params[:token]
          user = User.find_by(reset_password_token: token)
          if (Time.now - user.reset_password_sent_at) < 30.minutes
            user.update!(password: params[:password], reset_password_token: nil, reset_password_sent_at: nil)
            render json: {status: :success, message: :password_changed}, status: :ok
          else
            render json: {status: :failed, message: :time_is_up_resend_again}, status: :bad_request
          end
        rescue StandardError => e
          render json: {status: :failed, message: :resend_password_change_request, error: e}, status: :bad_request

        end

      end
    end
  end
end
