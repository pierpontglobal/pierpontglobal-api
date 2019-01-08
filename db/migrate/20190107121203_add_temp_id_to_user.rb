class AddTempIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :temp_id, :string
  end
end
