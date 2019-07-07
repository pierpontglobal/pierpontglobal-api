class AddTypeToVehicleCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicle_categories, :type_id, :integer, :foreign_key => true
  end
end
