class CreateHeavyVehicleRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :heavy_vehicle_requests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :heavy_vehicle, index: true, foreign_key: true
      t.integer :quantity
      t.string :status
      t.timestamps
    end
  end
end
