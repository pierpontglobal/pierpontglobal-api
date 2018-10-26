class AddMfaValidationToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_access_tokens, :mfa_authenticated, :boolean, default: false
  end
end
