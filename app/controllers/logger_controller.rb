class LoggerController < Doorkeeper::TokensController
  before_action :log_ip

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