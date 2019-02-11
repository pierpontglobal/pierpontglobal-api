class AddHoldingFundsToFunds < ActiveRecord::Migration[5.2]
  def change
    add_column :funds, :holding, :decimal, precision: 14, scale: 4
  end
end
