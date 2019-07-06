# frozen_string_literal: true
require 'sidekiq-scheduler'

class PullEquipmentFromPage
  include Sidekiq::Worker
  sidekiq_options queue: 'scrap_heavy_vehicles'

  def perform(*args)
    params = args.first
    worker = ::HeavyVehiclesWorker.new


    (params["start"]..params["end"]).each do |page|
      worker.get_for_page(page)
    end

    worker.get_vehicles.each do |vehicle|
      ::HeavyVehicle.create!(main_image: vehicle[:main_image],
                             title: vehicle[:title],
                             location: vehicle[:location],
                             price: vehicle[:price],
                             equipment_id: vehicle[:equipment_id],
                             description: vehicle[:description],
                             serial: vehicle[:serial],
                             type_id: vehicle[:type_id]
      )
    end
  end

end
