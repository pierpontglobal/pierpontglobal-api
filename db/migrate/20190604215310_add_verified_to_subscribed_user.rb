class AddVerifiedToSubscribedUser < ActiveRecord::Migration[5.2]
  def change
    add_column :subscribed_users, :verified_on, :datetime
  end
end
