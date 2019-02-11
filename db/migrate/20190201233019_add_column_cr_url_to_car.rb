class AddColumnCrUrlToCar < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :cr_url, :string
  end
end
