class AddColumnVerifyPhoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :verify_phone_status, :boolean, default: false
    add_column :users, :numeric_activation_token, :string
    add_column :users, :sent_date_activation_token, :datetime
  end
end
