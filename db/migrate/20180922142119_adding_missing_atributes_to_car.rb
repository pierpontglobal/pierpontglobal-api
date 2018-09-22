class AddingMissingAtributesToCar < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :sale_date, :datetime
    add_column :cars, :condition, :decimal, precision: 5, scale: 2
  end
end
