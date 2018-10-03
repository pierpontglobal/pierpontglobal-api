class FixAddressColumnInUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :street_address
    add_column :users, :primary_address, :string
    add_column :users, :secondary_address, :string
  end
end
