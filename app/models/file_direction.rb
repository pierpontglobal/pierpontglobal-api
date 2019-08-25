class FileDirection < ApplicationRecord
  belongs_to :car, optional: true

  scope :sanitized, lambda {
    select("array_to_json(array_agg(row(#{FileDirection.table_name}.route, #{FileDirection.table_name}.order))) AS car_images")
  }

end
