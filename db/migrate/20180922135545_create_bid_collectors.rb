class CreateBidCollectors < ActiveRecord::Migration[5.2]
  def change
    create_table :bid_collectors do |t|
      t.integer :count
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
