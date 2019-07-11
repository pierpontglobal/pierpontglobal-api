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
      heavy_vehicle = ::HeavyVehicle.find_by(equipment_id: vehicle[:equipment_id])
      if !heavy_vehicle.present?
        vehicle = ::HeavyVehicle.create!(
            main_image: vehicle[:main_image],
            title: vehicle[:title],
            location: vehicle[:location],
            price: vehicle[:price],
            equipment_id: vehicle[:source_id]
        )
        equipment_type = HeavyVehicleType.where("TRIM(lower(name)) = ?", vehicle[:equipment_type].downcase.gsub(" ", ""))[0]
        if !equipment_type.present?
          equipment_type = HeavyVehicleType.create!(name: vehicle[:equipment_type])
        end
        vehicle.type_id = equipment_type[:id]

        manufacturer = HeavyVehicleManufacturer.where("TRIM(lower(name)) = ?", vehicle[:manufacturer].downcase.gsub(" ", ""))[0]
        if !manufacturer.present?
          manufacturer = HeavyVehicleManufacturer.create!(name: vehicle[:manufacturer])
        end
        vehicle.manufacturer_id = manufacturer[:id]

        vehicle.save!

      else
        heavy_vehicle.update!(
            main_image: vehicle[:main_image],
            title: vehicle[:title],
            location: vehicle[:location],
            price: vehicle[:price]
        )
      end
    end
  end

end
