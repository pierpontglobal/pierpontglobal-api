class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.decimal :amount, precision: 14, scale: 4
      t.references :user, foreign_key: true
      t.references :bid_collector, foreign_key: true

      t.timestamps
    end
  end
end
