class CreateFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.integer :type
      t.string :value

      t.timestamps
    end
  end
end
