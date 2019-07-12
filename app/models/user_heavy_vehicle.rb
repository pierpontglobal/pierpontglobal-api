class UserHeavyVehicle < ApplicationRecord
  belongs_to :user
  belongs_to :heavy_vehicle

  def sanitized_with_user(user)
    {
        id: id,
        user: ::User.find(user_id),
        vehicle: ::HeavyVehicle.find(heavy_vehicle_id).sanitized_with_user(user),
        quantity: quantity
    }
  end
end
