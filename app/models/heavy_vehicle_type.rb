class HeavyVehicleType < ApplicationRecord

  scope :sanitized, lambda {
    select("#{HeavyVehicleType.table_name}.name AS heavy_vehicle_type")
  }

  def sanitized
    {
        id: id,
        name: name,
        categories: ::HeavyVehicleCategory.where(type_id: id).map(&:sanitized),
    }
  end

end
