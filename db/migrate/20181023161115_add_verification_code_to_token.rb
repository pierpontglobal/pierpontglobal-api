class AddVerificationCodeToToken < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_access_tokens, :phone_code, :string, null: true
    add_column :oauth_access_tokens, :phone_code_sent_at, :datetime, null: true
    add_column :oauth_access_tokens, :phone_code_valid_till, :integer, null: true
  end
end
