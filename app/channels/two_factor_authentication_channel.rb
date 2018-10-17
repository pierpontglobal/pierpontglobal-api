class TwoFactorAuthenticationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "two_factor_authentication_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
