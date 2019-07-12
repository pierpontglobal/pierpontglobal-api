class AddHeavyVehicleToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicle_images, :heavy_vehicle_id, :integer, :foreign_key => true
  end
end
