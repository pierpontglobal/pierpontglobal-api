class RelationshipBetweenCarsAndWinnerUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users_cars, id: false do |t|
      t.references :user, foreign_key: true
      t.references :car, foreign_key: true
    end

    execute 'ALTER TABLE users_cars ADD PRIMARY KEY (user_id, car_id);'
  end
end
