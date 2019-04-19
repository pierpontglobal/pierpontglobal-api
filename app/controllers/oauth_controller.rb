# frozen_string_literal: true

class OauthController < ApplicationController
  skip_before_action :doorkeeper_authorize!

  def application_name
    render json: ApplicationOath.find_by(pk: params[:pk]).name, status: :ok
  rescue StandardError => _e
    render json: 'Application does not exist', status: :not_found
  end

  def create_application
    data = ApplicationOath.create!(
      name: params[:name],
      callback: params[:callback]
    )
    render json: data, status: :ok
  end

  def authorized_user
    application_oauth = ApplicationOath.find_by(pk: params[:pk])
    if application_oauth.sk != params[:sk]
      render json: 'Wrong pk or sk.', status: :unauthorized
      return
    end
    application_oauth_user = OauthApplicationUser.find_by(token: params[:token])
    if Time.now > application_oauth_user.valid_until || !application_oauth_user.active
      render json: 'This token is no longer valid.', status: :unauthorized
      return
    end
    application_oauth_user.update(active: false)
    render json: application_oauth_user.user.sanitized, status: :ok
  rescue StandardError => _e
    render json: 'Application does not exist', status: :not_found
  end

  def authenticate
    user = ::User.find_by(username: params[:username])
    if user.valid_password?(params[:password])
      application_oauth = ApplicationOath.find_by(pk: params[:pk])
      user = OauthApplicationUser.create!(user: user, application_oath: application_oauth, valid_until: Time.now + 1.day)
      render json: { token: user.token, callback: application_oauth.callback }, status: :ok
    else
      throw StandardError
    end
  rescue StandardError => _e
    render json: 'Wrong credentials.', status: :unauthorized
  end

  private

  def authenticate_app
    pk = params[:pk]
    sk = params[:sk]
    uuid = params[:uuid]

    @oauth_app = ApplicationOath.where(pk: pk, sk: sk).first
    @current_user = OauthApplicationUser.find_by(application_oath: @oauth_app.id, user_id: uuid)
    unless @current_user.present?
      render json: { message: 'Authentication process failed for app' }, status: :unauthorized
      nil
    end
  end
end
