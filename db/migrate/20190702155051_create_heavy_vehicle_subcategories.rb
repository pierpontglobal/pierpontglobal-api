class CreateHeavyVehicleSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :heavy_vehicle_subcategories do |t|
      t.string :name
      t.timestamps
    end
  end
end
