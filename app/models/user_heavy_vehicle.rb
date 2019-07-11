class UserHeavyVehicle < ApplicationRecord
  belongs_to :user
  belongs_to :heavy_vehicle
end
