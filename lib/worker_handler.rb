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
        update_worker_number
        # ------------------- #
        sleep 5
      end
    end
  end

  def self.update_worker_number
    logger = Logger.new(STDOUT)
    logger.info "Scouting workers necessities"
    Sidekiq::Queue.all.each do |queue|
      queue_size = Sidekiq::Queue.new(queue.name).size
      required_workers_size = (queue_size/10.0).ceil
      workers_size = (required_workers_size - @worker_number)
      if workers_size > 0
        logger.info "Deploying: #{workers_size} workers"
        (0..workers_size).each do
          deploy_worker(queue.name)
        end
      else
        trim_workers
      end
    end
    if Sidekiq::Queue.all.size.zero?
      trim_workers
    end
  rescue StandardError => e
    logger.info e
  end

  def self.trim_workers
    logger = Logger.new(STDOUT)
    workers = Sidekiq::ProcessSet.new
    workers.each do |worker|
      if worker['busy'].zero?
        logger.info "Killing worker #{worker['hostname']}"
        @worker_number -= 1
        worker.stop!
      end
    end
  end

  def self.deploy_worker(queue)
    @worker_number += 1
    result = `aws ecs run-task --cluster #{@cluster_name} --network-configuration "awsvpcConfiguration={subnets=[#{@subnets}],securityGroups=[#{@security_group}],assignPublicIp='ENABLED'}" --launch-type FARGATE --started-by PPGWorkerHandler --task-definition #{@task_definition} --region $AWS_REGION --overrides "containerOverrides={name='SidekiqWorker',environment=[{name='QUEUENAME',value='#{queue}'}]}"`
    JSON.parse(result)
  end
end