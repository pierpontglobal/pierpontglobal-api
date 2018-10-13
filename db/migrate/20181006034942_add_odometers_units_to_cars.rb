class AddOdometersUnitsToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :odometer_unit, :string
  end
end
