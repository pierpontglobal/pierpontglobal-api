class AddVersionToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :release, :integer
  end
end
