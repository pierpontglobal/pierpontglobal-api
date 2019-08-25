class AddStepToBid < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :step, :integer, default: 0
  end
end
