class AddEngineInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :engine, :string
  end
end
