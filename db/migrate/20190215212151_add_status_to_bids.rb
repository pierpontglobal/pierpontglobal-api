class AddStatusToBids < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :status, :string
  end
end
