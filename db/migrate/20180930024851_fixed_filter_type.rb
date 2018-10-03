class FixedFilterType < ActiveRecord::Migration[5.2]
  def change
    rename_column :filters, :type, :scope
  end
end
