class CreateStepLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :step_logs do |t|
      t.references :step_group, foreign_key: true
      t.text :description
      t.string :title

      t.timestamps
    end
  end
end
