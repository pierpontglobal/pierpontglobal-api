class AddFieldHeavyVehicle < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicles, :class_code, :string
    add_column :heavy_vehicles, :year, :string
    add_column :heavy_vehicles, :meter, :string
  end
end
