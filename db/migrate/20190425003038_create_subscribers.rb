class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers, id: false do |t|
      t.references :user, foreign_key: true
      t.string :one_signal_uuid, null: false
    end

    add_index :subscribers, :one_signal_uuid, unique: true
  end
end
