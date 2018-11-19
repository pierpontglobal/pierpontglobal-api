# frozen_string_literal: true

module NotificationHandler
  def self.send_notification(message, model, id, title, receiver = nil)

    hash_data = {
      message: message,
      model: model,
      id: id,
      title: title,
      sent_date: Time.now
    }

    notification = Notification.create!(
      pending: true,
      data: hash_data
    )

    ActionCable.server.broadcast(
      receiver ? "admin_notification_single_#{receiver}" : 'admin_notification_to_admin',
      hash_data.merge!(notification_id: notification.id)
    )
  end
end