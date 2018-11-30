class FuelType < ApplicationRecord

  scope :sanitized, lambda {
    select("#{FuelType.table_name}.name AS car_fuel")
  }

end
