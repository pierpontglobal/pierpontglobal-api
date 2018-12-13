class SellerType < ApplicationRecord
  has_and_belongs_to_many :cars

  scope :sanitized, lambda {
    select("#{SellerType.table_name}.title AS car_seller_type")
  }

end
