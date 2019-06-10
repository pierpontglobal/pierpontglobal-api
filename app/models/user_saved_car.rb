class UserSavedCar < ApplicationRecord
  belongs_to :user
  belongs_to :car
end
