class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :funds, :past_balance, :balance
    rename_column :funds, :current_amount, :amount
    add_column :funds, :credit, :boolean
    add_column :funds, :source_id, :string
  end
end
