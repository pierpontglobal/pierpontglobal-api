class AddCategoryToVehicleSubcategory < ActiveRecord::Migration[5.2]
  def change
    add_column :heavy_vehicle_subcategories, :category_id, :integer, :foreign_key => true
  end
end
