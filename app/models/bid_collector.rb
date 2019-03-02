# frozen_string_literal: true

class BidCollector < ApplicationRecord
  belongs_to :car
  has_many :bids

  scope :with_action_date, lambda {
    select(:id, :count, :highest_id, :auction_start_date, :car_id)
      .left_joins(:car)
      .joins('INNER JOIN sale_informations ON bid_collectors.car_id = sale_informations.car_id')
      .order('auction_start_date ASC')
  }

  def create_structure
    {
      id: id,
      bids: bids.map(&:create_structure),
      count: count,
      highest_bid: highest_id ? ::Bid.find(highest_id).create_structure : nil,
      car: Car.where(id: car_id).sanitized.first.create_structure,
      auction_end: auction_start_date
    }
  end
end
