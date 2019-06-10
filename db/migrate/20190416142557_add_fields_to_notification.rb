class AddFieldsToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :read_at, :datetime
    add_column :notifications, :receiver_id, :integer
    add_column :notifications, :actor_id, :integer

    add_index :notifications, :receiver_id
    add_index :notifications, :actor_id
  end
end
