module PriceWorker
  class Instance
    Driver = PriceCrawl.new unless ENV['CONFIGURATION'] or ENV['SLAVE']
  end
end