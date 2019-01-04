class CreateFileDirections < ActiveRecord::Migration[5.2]
  def change
    create_table :file_directions do |t|
      t.references :car, foreign_key: true
      t.string :route
      t.integer :order
      t.string :description

      t.timestamps
    end
  end
end
