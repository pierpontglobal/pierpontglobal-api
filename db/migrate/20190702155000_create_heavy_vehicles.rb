class CreateHeavyVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :heavy_vehicles do |t|
      t.string :main_image
      t.string :title
      t.string :location
      t.decimal :price, precision: 4, scale: 2
      t.string :equipment_id
      t.string :description
      t.string :serial
      t.string :condition
      t.timestamps
    end
  end
end
