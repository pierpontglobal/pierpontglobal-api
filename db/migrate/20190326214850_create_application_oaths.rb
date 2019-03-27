class CreateApplicationOaths < ActiveRecord::Migration[5.2]
  def change
    create_table :application_oaths do |t|
      t.string :name
      t.string :pk
      t.string :sk

      t.timestamps
    end
  end
end
