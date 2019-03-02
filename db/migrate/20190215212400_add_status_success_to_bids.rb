class AddStatusSuccessToBids < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :success, :boolean
  end
end
