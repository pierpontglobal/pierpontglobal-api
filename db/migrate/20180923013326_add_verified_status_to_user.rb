class AddVerifiedStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :verified_by, foreign_key: { to_table: :users }
    add_column :users, :verified, :boolean
  end
end
