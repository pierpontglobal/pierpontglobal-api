class CreateAdquisitions < ActiveRecord::Migration[5.2]
  def change
    create_table :adquisitions do |t|
      t.references :car, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
