class Add2FAforUserValidation < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :require_2fa, :boolean
    remove_column :users, :sms_code
    remove_column :users, :sms_code_sent_date
    remove_column :users, :is_token_active
    remove_column :users, :verify_phone_status
    remove_column :users, :numeric_activation_token
    remove_column :users, :sent_date_activation_token
  end
end
