class AddAttributesToDealer < ActiveRecord::Migration[5.2]
  def change
    add_column :dealers, :country, :string
    add_column :dealers, :city, :string
    add_column :dealers, :address1, :string
    add_column :dealers, :address2, :string
  end
end
