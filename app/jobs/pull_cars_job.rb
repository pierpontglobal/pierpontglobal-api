class PullCarsJob
  include Sidekiq::Worker
  def perform(*args)
    populator = DataPopulator.new
    populator.update_car_data
    # PullCarsJob.set(wait: 1.minute).perform_later
    puts 'CARS PULLED'
    PullCarsJob.perform_at(1.hour.from_now)
  end
end
































































































