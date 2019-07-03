# frozen_string_literal: true
require 'sidekiq-scheduler'

class ScrabHeavyVehicles
  include Sidekiq::Worker
  sidekiq_options queue: 'scrap_heavy_vehicles'

  def perform(*_args)
    worker = ::HeavyVehiclesWorker.new
    total_pages = worker.get_total_pages

    total_pages = 3
    @page = 1
    while @page < total_pages
      worker.get_for_page(page)
      page_vehicles = worker.get_vehicles
      save_vehicles(page_vehicles)
      worker.set_vehicles([])
      @page = @page + 1
    end
  end

  def save_vehicles(vehicles)
    puts "Vehicle for page: #{@page}"
    puts vehicles.inspect
  end

end