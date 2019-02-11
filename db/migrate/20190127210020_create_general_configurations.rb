class CreateGeneralConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :general_configurations, {:id => false} do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
    execute "ALTER TABLE general_configurations ADD PRIMARY KEY (key);"
  end
end
