class CreateStepGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :step_groups do |t|
      t.string :name
      t.integer :step_number
      t.text :description

      t.timestamps
    end
  end
end
