class AddAdquisitionToStepLog < ActiveRecord::Migration[5.2]
  def change
    add_reference :step_logs, :adquisition, foreign_key: true
  end
end
