class ChangeColumnType < ActiveRecord::Migration[5.2]
  def change
    remove_column :cars, :whole_price
    add_column :cars, :whole_price, :integer
  end
end
