class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.json :data
      t.boolean :pending

      t.timestamps
    end
  end
end
