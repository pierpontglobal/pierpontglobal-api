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
      heavy_vehicle = ::HeavyVehicle.find_by(equipment_id: vehicle[:source_id])
      if !heavy_vehicle.present?
        ::HeavyVehicle.create!(
            main_image: vehicle[:main_image],
            title: vehicle[:title],
            location: vehicle[:location],
            price: vehicle[:price],
            equipment_id: vehicle[:source_id]
        )
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
