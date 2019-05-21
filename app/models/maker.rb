# frozen_string_literal: true

class Maker < ApplicationRecord
  has_many :models

  scope :sanitized, lambda {
    select("#{Maker.table_name}.name AS car_maker")
  }

  def sanitazed_info
    {
        id: id,
        name: name
    }
  end
end
