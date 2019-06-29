module PriceWorker
  class Instance
    Driver = PriceCrawl.new unless ENV['CONFIGURATION']
  end
end