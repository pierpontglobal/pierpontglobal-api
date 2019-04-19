class AddCustomIdToIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :issues, :custom_id, :integer
  end
end
