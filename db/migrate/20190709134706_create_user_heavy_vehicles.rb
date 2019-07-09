class CreateUserHeavyVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_heavy_vehicles do |t|
      t.references :user, index: true, foreign_key: true
      t.references :heavy_vehicle, index: true, foreign_key: true
      t.integer :quantity
      t.timestamps
    end
  end
end
