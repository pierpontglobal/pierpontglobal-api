class Location < ApplicationRecord
  scope :sanitized, lambda {
    select(
      :id,
      :name,
      :mh_id
    )
  }
end
