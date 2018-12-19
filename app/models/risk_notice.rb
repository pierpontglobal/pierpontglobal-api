class RiskNotice < ApplicationRecord
  belongs_to :user, optional: true

  scope :sanitize, lambda {
    select(
      :id,
      :maxmind_risk,
      :status,
      :message,
      :created_at
    )
  }

end
