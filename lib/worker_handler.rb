require 'sidekiq/api'
require 'json'

module WorkerHandler
  def self.activate
    @cluster_name = 'PierpontGlobal'
    @subnets = "'subnet-0e16fcd46d77039d5','subnet-28d7464f','subnet-0d6d14001b88f60d4'"
    @security_group = "'sg-0903654f2c06b4b19'"
    @task_definition = 'SidekiqWorker:50'

    @worker_number = 0

    Thread.new do
      while true do
        enqueue_jobs
        update_worker_number
        # ------------------- #
        sleep 1.minute
      end
    end

  rescue
    logger = Logger.new(STDOUT)
    logger.info 'Sidekiq not ready'
  end

  def self.update_worker_number
    logger = Logger.new(STDOUT)
    logger.info "Scouting workers necessities"

    queue_size = Sidekiq::Queue.all.map(&:size).sum
    required_workers_size = (queue_size/10.0).ceil
    remaining_workers = (required_workers_size - @worker_number)

    if remaining_workers > 0
      Sidekiq::Queue.all.each do |queue|
        logger.info "Deploying: #{remaining_workers} workers"
        logger.info "Active workers #{@worker_number}"
        (0...remaining_workers).each do
          deploy_worker(queue.name)
        end
      end
    else
      trim_workers
    end
  rescue
    logger.info 'Sidekiq not ready'
  end

  def self.trim_workers
    logger = Logger.new(STDOUT)
    workers = Sidekiq::ProcessSet.new
    workers.each do |worker|
      if worker['busy'].zero?
        logger.info "Killing worker #{worker['hostname']}"
        @worker_number -= 1 unless @worker_number <= 0
        worker.stop!
      end
    end
  end

  def self.enqueue_jobs
    logger = Logger.new(STDOUT)
    Sidekiq::ScheduledSet.new.each do |ss|
      if (ss.created_at - ss.at) > 0
        ss.add_to_queue
      end
    end

    Sidekiq::RetrySet.new.retry_all
  rescue
    logger.info 'Sidekiq not ready'
  end

  def self.deploy_worker(queue)
    @worker_number += 1
    result = `aws ecs run-task --cluster #{@cluster_name} --network-configuration "awsvpcConfiguration={subnets=[#{@subnets}],securityGroups=[#{@security_group}],assignPublicIp='ENABLED'}" --launch-type FARGATE --started-by PPGWorkerHandler --task-definition #{@task_definition} --region $AWS_REGION --overrides "containerOverrides={name='SidekiqWorker',environment=[{name='QUEUENAME',value='#{queue}'}]}"`
    JSON.parse(result)
  end
end