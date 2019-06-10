class AddStarredToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :starred, :boolean, default: false
  end
end
