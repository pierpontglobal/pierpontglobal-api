class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.integer :year
      t.references :model, foreign_key: true
      t.string :tim
      t.integer :odometer
      t.references :fuel_type, foreign_key: true
      t.string :displacement
      t.boolean :transmission
      t.string :vin, uniq: true
      t.references :body_style, foreign_key: true
      t.integer :doors
      t.references :vehicle_type, foreign_key: true

      t.timestamps
    end
    add_index :cars, :vin, unique: true
  end
end
