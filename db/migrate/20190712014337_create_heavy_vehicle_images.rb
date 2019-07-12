class CreateHeavyVehicleImages < ActiveRecord::Migration[5.2]
  def change
    create_table :heavy_vehicle_images do |t|
      t.string :image
      t.timestamps
    end
  end
end
