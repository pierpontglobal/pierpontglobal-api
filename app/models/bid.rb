# frozen_string_literal: true

# Bid model description
class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :bid_collector

  scope :attach_vehicle_info, lambda {
    select('amount', 'id', 'bid_collectors.car_id', 'vin', 'year', 'trim', 'bid_collectors.id AS bid_collector_id')
      .joins('INNER JOIN bid_collectors ON bid_collectors.id = bid_collector_id')
      .joins('INNER JOIN cars ON cars.id = bid_collectors.car_id')
      .joins('INNER JOIN models ON models.id = model_id').merge(Model.sanitized)
      .joins('INNER JOIN sale_informations ON bid_collectors.car_id = sale_informations.car_id').merge(SaleInformation.sanitize)
  }

  scope :sanitized, lambda {
    select('bids.id as bid_id', 'amount', 'user_id', 'bid_collector_id', 'status', 'success')
      .joins('INNER JOIN bid_collectors ON bid_collectors.id = bid_collector_id')
      .joins('INNER JOIN cars ON cars.id = bid_collectors.car_id').merge(Car.sanitized_referenced)
  }

  def create_structure
    {
      bid_details: self,
      user: user,
      car_details: Car.where(id: bid_collector.car.id).sanitized.first.create_structure
    }
  end
end
