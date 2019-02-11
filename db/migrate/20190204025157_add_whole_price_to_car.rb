class AddWholePriceToCar < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :whole_price, :string
  end
end
