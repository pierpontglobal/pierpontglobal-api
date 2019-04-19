# frozen_string_literal: true

class AdminNotificationChannel < ApplicationCable::Channel
  def subscribed
    puts '>>>>>>>>>>>>>>>>>>>>>>>'
    puts current_user.inspect
    stream_from "admin_notification_single_#{params[:user_id]}"
    stream_from 'admin_notification_to_admin'
  end

  def show_pending
    notifications = []
    Notification.where(pending: true).each do |notification|
      data = notification.data
      data[:notification_id] = notification.id
      notifications.push(data)
    end

    ActionCable.server.broadcast(
      "admin_notification_single_#{params[:user_id]}",
      notifications
    )
  end

  def send_notifications; end

  def unsubscribe
    # Any cleanup needed when channel is unsubscribed
  end
end
