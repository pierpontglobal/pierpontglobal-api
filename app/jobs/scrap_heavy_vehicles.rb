# frozen_string_literal: true
require 'sidekiq-scheduler'

class ScrapHeavyVehicles
  include Sidekiq::Worker
  sidekiq_options queue: 'scrap_heavy_vehicles'

  def perform(*_args)
    worker = ::HeavyVehiclesWorker.new
    total_pages = worker.get_total_pages


    (1..total_pages).each do |page|
      PullEquipmentFromPage.perform_async({start: page, end: page + 1})
    end
  end

end