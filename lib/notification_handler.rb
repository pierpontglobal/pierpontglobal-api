# frozen_string_literal: true

module NotificationHandler
  def self.send_notification(title, message, payload, receiver_id, type = Notification::INFO_NOTIFICATION, issue_id = nil, actor_id = 1)

    hash_data = {
      message: message,
      title: title,
      payload: payload,
      sent_date: Time.now,
    }

    # TODO: (NOT SURE, no time to think) Verify if notification exists before create it, if it does, just update the read_at to nil, if not, create it.
    # If we do this, then, the READ notifications won't be accurate. So I think a better process will be to DELETE read notifications that
    #   has been there for more than one week

    notification = Notification.create!(
      pending: true,
      data: hash_data,
      receiver_id: receiver_id,
      actor_id: actor_id,
      notification_type: type,
      issues_id: issue_id
    )

    ActionCable.server.broadcast(
      receiver_id ? "admin_notification_single_#{receiver_id}" : 'admin_notification_to_admin',
      hash_data.merge!(notification_id: notification.id, notification_type: type)
    )
  end
end