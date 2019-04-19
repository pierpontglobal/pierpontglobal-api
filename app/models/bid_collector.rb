# frozen_string_literal: true

class BidCollector < ApplicationRecord
  belongs_to :car
  has_many :bids

  scope :with_auction_date, lambda {
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

  def self.notify_change(bid_collector)
    car = Car.where(id: bid_collector.car_id).sanitized.first
    sale_information = car.sale_information
    highest_bid = nil
    highest_bid = ::Bid.find(bid_collector.highest_id) if bid_collector.highest_id.present?

    bid_structure = {
      id: bid_collector.id,
      bids: bid_collector.bids.map(&:create_structure),
      count: count,
      highest_bid: highest_bid.create_structure,
      car: car.create_structure,
      auction_end: sale_information.auction_start_date
    }
    ActionCable.server.broadcast('bid_status_channel', bid_structure.to_json)
  end

  def inspect_attributes
    update!(
      count: bids.size,
      highest_id: bids.where(status: 'active').order(amount: :desc).first.id
    )
    destroy! if count.zero?
  end
end
