class HeavyVehicleCategory < ApplicationRecord

  def sanitized
    {
        id: id,
        name: name,
        subcategories: ::HeavyVehicleSubcategory.where(:category_id => id).map(&:sanitized)
    }
  end
end
