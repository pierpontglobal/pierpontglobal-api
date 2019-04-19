class CreateOauthApplicationUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :oauth_application_users do |t|
      t.references :application_oath, foreign_key: true
      t.string :token
      t.datetime :valid_until
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
