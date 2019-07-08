class IncreaseDecimalsToHeavyVehicles < ActiveRecord::Migration[5.2]
  def change
    change_column :heavy_vehicles, :price, :decimal, precision: 10, scale: 2
  end
end
