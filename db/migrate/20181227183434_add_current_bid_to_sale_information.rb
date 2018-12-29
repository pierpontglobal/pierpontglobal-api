class AddCurrentBidToSaleInformation < ActiveRecord::Migration[5.2]
  def change
    add_column :sale_informations, :current_bid, :decimal, precision: 13, scale: 2
  end
end
