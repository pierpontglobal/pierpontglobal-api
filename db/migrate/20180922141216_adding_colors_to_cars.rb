class AddingColorsToCars < ActiveRecord::Migration[5.2]
  def change
    add_reference :cars, :interior_color, foreign_key: { to_table: :colors }
    add_reference :cars, :exterior_color, foreign_key: { to_table: :colors }
  end
end
