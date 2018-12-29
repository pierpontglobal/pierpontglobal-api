# frozen_string_literal: true

#  Car sale information
class SaleInformation < ApplicationRecord
  belongs_to :car

  scope :sanitize, lambda {
    select(
      :channel,
      :sale_date,
      :action_id,
      :action_start_date,
      :action_end_date,
      :auction_location
    )
  }
end
