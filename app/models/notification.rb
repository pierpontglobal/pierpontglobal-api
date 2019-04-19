class Notification < ApplicationRecord
  belongs_to :user, :foreign_key => 'receiver_id'
  belongs_to :user, :foreign_key => 'actor_id'
  has_many :issues

  # Notification types
  ALERT_NOTIFICATION = "alert"
  INFO_NOTIFICATION = "info"

  def sanitazed_info
    {
        id: id,
        read_at: read_at,
        created_at: created_at,
        data: data,
        pending: pending,
        receiver: User.find(receiver_id).sanitized,
        actor: User.find(actor_id).sanitized,
        notification_type: notification_type,
        issue: !issues_id.nil? ? Issue.find(issues_id).sanitazed_info : nil,
    }
  end
end
