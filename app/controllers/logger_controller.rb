# frozen_string_literal: true

# Handles the login system for the sign-in process.
class LoggerController < Doorkeeper::TokensController
  def create
    super
    user = User.find_by_username params[:username]
    rbj = JSON.parse(response.body)
    try_count = user.try_count
    if try_count >= 5
      UnblockUserJob.perform_at(30.minutes.from_now, id: user.id, username: user.username)
      self.response_body = { error: 'User blocked', message: ::TEXT_RESPONSE[:try_blocked] }.to_json
    elsif response_code == 200
      log_ip(user)
      user.reset_try_count
      active_status = user.active?
      rbj.merge!(active: active_status[:status], reason: active_status[:reason]).to_json
      self.response_body = rbj.to_json
    elsif response_code == 401
      rbj.merge!(try_count: try_count).to_json
      self.response_body = rbj.to_json
    end
  rescue NoMethodError
    nil
  end

  private

  def log_ip(user)
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
