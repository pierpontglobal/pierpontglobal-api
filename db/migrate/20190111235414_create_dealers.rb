class CreateDealers < ActiveRecord::Migration[5.2]
  def change
    create_table :dealers do |t|
      t.string :name
      t.decimal :latitude, precision: 12, scale: 8
      t.decimal :longitude, precision: 12, scale: 8
      t.references :user, foreign_key: true
      t.string :phone_number

      t.timestamps
    end
  end
end
