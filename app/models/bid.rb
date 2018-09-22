class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :bid_collector
end
