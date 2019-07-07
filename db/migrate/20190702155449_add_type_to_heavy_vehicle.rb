class AddTypeToHeavyVehicle < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicles, :type_id, :integer, :foreign_key => true
  end
end
