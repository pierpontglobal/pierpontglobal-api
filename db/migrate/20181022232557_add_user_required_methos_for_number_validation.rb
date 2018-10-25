class AddUserRequiredMethosForNumberValidation < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :verification_code, :string, null: true
  end
end
