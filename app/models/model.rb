class Model < ApplicationRecord
  belongs_to :maker, optional: true

  scope :sanitized, lambda {
    select("#{Model.table_name}.name AS car_model")
      .joins(:maker)
      .merge(Maker.sanitized)
  }

end
