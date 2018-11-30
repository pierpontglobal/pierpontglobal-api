class Maker < ApplicationRecord
  has_many :models

  scope :sanitized, lambda {
    select("#{Maker.table_name}.name AS car_maker")
  }
end
