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

  def sanitized
    price_percentage_config = ::GeneralConfiguration.find_by(:key => 'heavy_vehicle_price_percentage')
    increase_price_percentage = price_percentage_config[:value].to_f
    {
        id: id,
        title: title,
        main_image: main_image,
        location: location,
        price: price * (1 + increase_price_percentage),
        equipment_id: equipment_id,
        description: description,
        serial: serial,
        condition: condition,
        type: type_id.present? ? ::HeavyVehicleType.find(type_id) : nil
    }
  end

end
