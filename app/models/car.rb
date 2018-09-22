class Car < ApplicationRecord
  belongs_to :model
  belongs_to :fuel_type
  belongs_to :exterior_color
  belongs_to :body_style
  belongs_to :vehicle_type
end
