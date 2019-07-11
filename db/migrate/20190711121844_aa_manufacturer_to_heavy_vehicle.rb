class AaManufacturerToHeavyVehicle < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicles, :manufacturer_id, :integer, :foreign_key => true
  end
end
