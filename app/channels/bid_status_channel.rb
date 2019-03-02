# frozen_string_literal: true

# Manages the background task for admin
class BidStatusChannel < ApplicationCable::Channel
  before_subscribe :user_admin?

  def subscribed
    stream_from "bid_status_channel"
  end

  private

  def user_admin?
    unless current_user.has_role? :admin
      ActionCable
          .server
          .remote_connections
          .where(current_user: current_user)
          .disconnect
    end
  end
end
