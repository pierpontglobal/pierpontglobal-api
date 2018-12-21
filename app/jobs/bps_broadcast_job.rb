class BPSBroadcastJob
  include Sidekiq::Worker
  sidekiq_options queue: 'broadcast_job'

  def perform(channel, continuous = nil)

    queues = []
    retries = []

    ss = Sidekiq::ScheduledSet.new
    ss.select.each { |queue| queues << queue_info(queue) }

    rs = Sidekiq::RetrySet.new
    rs.select.each { |retry_| retries << retry_info(retry_) }

    stats = Sidekiq::Stats.new
    queues_stats = stats.queues

    message = {
      workers: Sidekiq::ProcessSet.new,
      jobs: [
        Sidekiq::Queue.new('car_pulling')
      ],
      queues: queues,
      retries: retries,
      stats: stats,
      queues_stats: queues_stats
    }

    ActionCable.server.broadcast(channel,
                                 message)
    if continuous
      BPSBroadcastJob.perform_in(1.second,
                                 channel, 1.second)
    end
  end

  private

  def queue_info(queue)
    {
      id: queue.jid,
      queue: queue.queue,
      value: queue.item
    }
  end

  def retry_info(retry_)
    {
      id: retry_.jid,
      queue: retry_.queue,
      value: retry_.item
    }
  end

end