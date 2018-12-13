class VehicleType < ApplicationRecord
  scope :sanitized, lambda {
    select("#{VehicleType.table_name}.name AS car_vehicle_type",
           "#{VehicleType.table_name}.type_code AS car_type_code")
  }
end
