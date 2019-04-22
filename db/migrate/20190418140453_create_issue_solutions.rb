class CreateIssueSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_solutions do |t|
      t.string :name
      t.string :description
      t.string :velocity

      t.timestamps
    end
  end
end
