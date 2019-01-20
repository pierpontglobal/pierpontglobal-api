class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.boolean :payment_status
      t.string :stripe_reference
      t.date :payment_date
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
