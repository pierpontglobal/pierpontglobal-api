# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'set'

class CarReindexJob
  include Sidekiq::Worker
  sidekiq_options queue: 'car_pulling'

  def perform(args)
    # Car.reindex
  end
end
