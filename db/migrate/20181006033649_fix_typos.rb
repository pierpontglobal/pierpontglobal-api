class FixTypos < ActiveRecord::Migration[5.2]
  def change
    remove_column :cars, :tim
    add_column :cars, :trim, :string
  end
end
