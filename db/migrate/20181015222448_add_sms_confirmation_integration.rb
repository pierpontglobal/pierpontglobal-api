class AddSmsConfirmationIntegration < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sms_code, :string
    add_column :users, :sms_code_sent_date, :datetime
    add_column :users, :phone_number_validated, :boolean
  end
end
