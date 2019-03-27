class AddCallbackToApplicationOath < ActiveRecord::Migration[5.2]
  def change
    add_column :application_oaths, :callback, :string
  end
end