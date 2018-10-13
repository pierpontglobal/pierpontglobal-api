class VehicleTypeModification < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicle_types, :type_code, :string
  end
end
