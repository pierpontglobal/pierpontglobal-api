class AddUserRequiredMethosForConfirmation2 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_code_sent_at, :datetime, null: true
    add_column :users, :activation_code_valid_for, :integer, null: true
  end
end
