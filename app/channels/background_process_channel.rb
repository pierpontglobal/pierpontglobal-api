# frozen_string_literal: true

# Manages the background task for admin
class BackgroundProcessChannel < ApplicationCable::Channel

  def subscribed
    stream_from "background_process_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
