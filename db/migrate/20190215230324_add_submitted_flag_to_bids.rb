class AddSubmittedFlagToBids < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :submitted, :boolean
  end
end
