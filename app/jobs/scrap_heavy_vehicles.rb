# frozen_string_literal: true
require 'sidekiq-scheduler'

class ScrapHeavyVehicles
  include Sidekiq::Worker
  sidekiq_options queue: 'car_pulling'

  def perform(*_args)
    total_pages = ::HeavyVehiclesWorker.get_total_pages


    (1..total_pages).step(10) do |page|
      PullEquipmentFromPage.perform_async({start: page, end: page + 9})
    end
  end

end