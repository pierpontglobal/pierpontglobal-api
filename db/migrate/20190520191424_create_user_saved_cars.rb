class CreateUserSavedCars < ActiveRecord::Migration[5.2]
  def change
    create_table :user_saved_cars do |t|
      t.references :user, index: true, foreign_key: true
      t.references :car, index: true, foreign_key: true
    end
  end
end
