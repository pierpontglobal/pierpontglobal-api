class HeavyVehicleSubcategory < ApplicationRecord
  def sanitized
    {
        id: id,
        name: name
    }
  end
end
