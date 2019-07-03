require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler'
require 'sidekiq-scheduler/web'

redis = { url: (ENV['JOB_WORKER_URL'] || 'redis://redis:6379/0'), namespace: 'sidekiq' }

Sidekiq.configure_server do |config|
  config.redis = redis
  config.on(:startup) do
    SidekiqScheduler::Scheduler.instance.rufus_scheduler_options = { max_work_threads: 1 }
    Sidekiq.schedule = ConfigParser.parse(File.join(Rails.root, "config/sidekiq-scheduler-jobs.yml"), Rails.env)
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['PIERPONT_USER_SIDEKIQ'], ENV['PIERPONT_PASS_SIDEKIQ']]
end

Sidekiq.configure_client do |config|
  config.redis = redis
end