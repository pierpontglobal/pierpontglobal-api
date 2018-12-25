class BidCollector < ApplicationRecord
  belongs_to :car
  has_many :bids
end
