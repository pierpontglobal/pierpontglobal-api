class CreateRiskNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_notices do |t|
      t.references :user, foreign_key: true, null: true
      t.decimal :maxmind_risk, precision: 5, scale: 2
      t.string :status
      t.string :message

      t.timestamps
    end
  end
end
