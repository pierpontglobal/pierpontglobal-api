# frozen_string_literal: true

class LoggerController < Doorkeeper::TokensController
  before_action :log_ip

  def create
    super
    user = User.find_by_username params[:username]
    rbj = JSON.parse(response.body)
    if user.try_count >= 5
      self.response_body = {error: 'User blocked', message: ::TEXT_RESPONSE[:try_blocked]}.to_json
    elsif response_code == 200
      user.reset_try_count
      active_status = user.active?
      rbj.merge!(active: active_status[:status], reason: active_status[:reason]).to_json
      self.response_body = rbj.to_json
    elsif response_code == 401
      rbj.merge!(try_count: user.try_count).to_json
      self.response_body = rbj.to_json
    end
  end

  def log_ip
    if doorkeeper_token
      user = User.find(doorkeeper_token.resource_owner_id)

      # Counts sign in amount
      user.sign_in_count = user.sign_in_count + 1

      # Updates the currently signed in ip for token
      user.last_sign_in_ip = user.current_sign_in_ip
      user.current_sign_in_ip = request.remote_ip

      # Updates the current and last sign in dates
      user.last_sign_in_at = user.current_sign_in_at
      user.current_sign_in_at = DateTime.now
      user.save!
    end
  end
end
