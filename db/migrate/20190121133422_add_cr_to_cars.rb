class AddCrToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :condition_report, :decimal, precision: 3, scale: 2
  end
end
