class BodyStyle < ApplicationRecord
  scope :sanitized, lambda {
    select("#{BodyStyle.table_name}.name AS car_body_style")
  }
end
