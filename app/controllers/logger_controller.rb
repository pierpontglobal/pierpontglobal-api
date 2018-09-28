class LoggerController < Doorkeeper::TokensController
  before_action :log_ip

  def log_ip
    user = User.find(doorkeeper_token.resource_owner_id)
    user.sign_in_count = user.sign_in_count + 1
    user.last_sign_in_ip = user.current_sign_in_ip
    user.current_sign_in_ip = request.remote_ip
    user.save!
  end
end