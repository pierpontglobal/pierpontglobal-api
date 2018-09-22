class AddReferencesBidsToBidsCollector < ActiveRecord::Migration[5.2]
  def change
    add_reference :bid_collectors, :highest, foreign_key: { to_table: :bids }
  end
end
