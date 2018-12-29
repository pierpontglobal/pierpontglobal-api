class SetPrimaryKey < ActiveRecord::Migration[5.2]
  def change
    change_column :cars_seller_types, :car_id, :integer, primary_key: true
    change_column :cars_seller_types, :seller_type_id, :integer, primary_key: true
  end
end
