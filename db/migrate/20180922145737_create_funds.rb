class CreateFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :funds do |t|
      t.decimal :past_balance, precision: 14, scale: 4
      t.decimal :current_amount, precision: 14, scale: 4
      t.references :user, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
