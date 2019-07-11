class AddColumnToHeavyVehicles < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicles, :category, :string
    add_column :heavy_vehicles, :sub_category, :string
  end
end
