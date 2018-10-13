class CreateJoinTableCarSellerType < ActiveRecord::Migration[5.2]
  def change
    create_join_table :cars, :seller_types do |t|
      t.index [:car_id, :seller_type_id]
      # t.index [:seller_type_id, :car_id]
    end
  end
end
