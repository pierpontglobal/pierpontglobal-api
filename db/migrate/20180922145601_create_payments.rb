class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 14, scale: 4
      t.boolean :verified
      t.text :payment_note
      t.references :verified_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
