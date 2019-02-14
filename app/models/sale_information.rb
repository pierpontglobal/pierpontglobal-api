# frozen_string_literal: true

#  Car sale information
class SaleInformation < ApplicationRecord
  belongs_to :car

  scope :sanitize, lambda {
    select(
      "#{SaleInformation.table_name}.channel",
      "#{SaleInformation.table_name}.sale_date",
      "#{SaleInformation.table_name}.auction_id",
      "#{SaleInformation.table_name}.auction_start_date",
      "#{SaleInformation.table_name}.auction_end_date",
      "#{SaleInformation.table_name}.action_location"
    )
  }
end
