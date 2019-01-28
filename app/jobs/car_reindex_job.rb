# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'set'

class CarReindexJob
  include Sidekiq::Worker
  sidekiq_options queue: 'car_pulling'

  def perform(args)
    size = Sidekiq::Queue.new('car_pulling').size + Sidekiq::Workers.new.size + Sidekiq::RetrySet.new.size + Sidekiq::ScheduledSet.new.size
    while size > 1
      sleep(5.seconds)
      size = Sidekiq::Queue.new('car_pulling').size + Sidekiq::Workers.new.size + Sidekiq::RetrySet.new.size + Sidekiq::ScheduledSet.new.size
    end

    Car.where("release < #{args.first} or release is null").each do |c|
      Car.searchkick_index.remove c
    end
  end
end
