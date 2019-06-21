# frozen_string_literal: true

# Manages the background task for admin
class BackgroundProcessChannel < ApplicationCable::Channel
  before_subscribe :user_admin?

  def subscribed
    stream_from "background_process_channel_#{current_user.id}"
    BPSBroadcastJob.perform_async("background_process_channel_#{current_user.id}", true)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def kill_job
    # TODO: Allow admin to kill a task
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
