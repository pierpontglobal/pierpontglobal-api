# frozen_string_literal: true
require 'sidekiq-scheduler'

class PullEquipmentFromPage
  include Sidekiq::Worker
  sidekiq_options queue: 'car_pulling'

  def perform(*args)
    params = args.first
    vehicles = []

    (params["start"]..params["end"]).each do |page|
      vehicles = vehicles | ::HeavyVehiclesWorker.get_for_page(page)
    end

    vehicles.each do |vehicle|
      puts 'Vehicle to save >>>>>>>>>>>>>>>>  >>>>>>>>>>>>>>>>>>>>>>>'
      puts vehicle.inspect
      heavy_vehicle = ::HeavyVehicle.find_by(equipment_id: vehicle[:ur_id])
      if !heavy_vehicle.present?
        created_vehicle = ::HeavyVehicle.create!(
            main_image: vehicle[:main_image],
            title: vehicle[:title],
            location: vehicle[:location],
            price: vehicle[:price],
            equipment_id: vehicle[:ur_id],
            description: vehicle["description"],
            serial: vehicle["serial"]
        )
        equipment_type = HeavyVehicleType.where("lower(name) = ?", vehicle["equipment_type"].to_s.downcase)[0]
        if !equipment_type.present?
          equipment_type = HeavyVehicleType.create!(name: vehicle["equipment_type"])
        end
        created_vehicle.type_id = equipment_type[:id]

        manufacturer = HeavyVehicleManufacturer.where("lower(name) = ?", vehicle["manufacturer"].to_s.downcase)[0]
        if !manufacturer.present?
          manufacturer = HeavyVehicleManufacturer.create!(name: vehicle["manufacturer"])
        end
        created_vehicle.manufacturer_id = manufacturer[:id]

        created_vehicle.save!

      else
        heavy_vehicle.update!(
            main_image: vehicle[:main_image],
            title: vehicle[:title],
            location: vehicle[:location],
            price: vehicle[:price],
            equipment_id: vehicle[:ur_id],
            description: vehicle["description"],
            serial: vehicle["serial"]
        )
      end
    end
  end

end
