class CreateSaleInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :sale_informations do |t|
      t.references :car, foreign_key: true
      t.string :channel
      t.date :sale_date
      t.string :auction_id
      t.datetime :auction_start_date
      t.datetime :auction_end_date
      t.string :action_location

      t.timestamps
    end
  end
end
