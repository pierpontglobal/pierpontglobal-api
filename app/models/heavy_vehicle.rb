class HeavyVehicle < ApplicationRecord
  searchkick word_middle: [:heavy_vehicle_identifier],
             callbacks: :async

  def search_data
    {
        heavy_vehicle_identifier: "#{title} #{location} #{equipment_id}",
        fielddata: true
    }
  end

  scope :sanitized, lambda {
    select(:id,
           :main_image,
           :title,
           :location,
           :equipment_id,
           :description,
           :serial,
           :type_id,
           :price)
        .left_joins(:heavy_vehicle_types).merge(Model.sanitized)
  }

end
