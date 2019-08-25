require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler'
require_relative './json_utilities'

sidekiq_config = {
    url: ENV.fetch('JOB_WORKER_URL')
}

puts "Sidekiq.server? is #{Sidekiq.server?.inspect}"
puts "defined?(Rails::Server) is #{defined?(Rails::Server).inspect}"
puts "defined?(Unicorn) is #{defined?(Unicorn).inspect}"


if ENV.fetch('QUEUENAME') === 'default'
  p 'Allowed'
  Sidekiq::Scheduler.enabled = true
else
  p 'NOT Allowed'
  Sidekiq::Scheduler.enabled = false
end

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.join(__dir__, '../sidekiq-scheduler-jobs.yml'))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['PIERPONT_USER_SIDEKIQ'], ENV['PIERPONT_PASS_SIDEKIQ']]
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end