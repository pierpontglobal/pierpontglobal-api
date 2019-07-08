class HeavyVehicleType < ApplicationRecord

  scope :sanitized, lambda {
    select("#{HeavyVehicleType.table_name}.name AS heavy_vehicle_type")
  }

end
