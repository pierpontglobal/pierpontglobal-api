class SellerType < ApplicationRecord
  has_and_belongs_to_many :cars

  scope :sanitized, lambda {
    select("array_remove(array_agg(#{SellerType.table_name}.title), NULL) AS car_seller_type")
  }

end
