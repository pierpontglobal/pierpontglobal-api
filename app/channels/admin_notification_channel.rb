# frozen_string_literal: true

class AdminNotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'admin_notification_to_admin'
    stream_from "admin_notification_single_#{current_user.id}"
  end

  def show_pending
    notifications = []
    Notification.where(pending: true).each do |notification|
      data = notification.data
      data[:notification_id] = notification.id
      notifications.push(data)
    end

    ActionCable.server.broadcast(
      "admin_notification_single_#{current_user.id}",
      notifications
    )
  end

  def send_notifications; end

  def unsubscribe
    # Any cleanup needed when channel is unsubscribed
  end
end
