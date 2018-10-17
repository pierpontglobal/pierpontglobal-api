class AddTokenActiveStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_token_active, :boolean, default: false
  end
end
