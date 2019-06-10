require 'sidekiq/api'

module WorkerHandler
  def self.activate
    @cluster_name = 'PierpontGlobal'
    @subnets = "'subnet-0e16fcd46d77039d5','subnet-28d7464f','subnet-0d6d14001b88f60d4'"
    @security_group = "'sg-0903654f2c06b4b19'"
    @task_definition = 'SidekiqWorker:48'

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
      workers_size = (queue_size/10.0).ceil

    end
  rescue
    logger.info "Sidekiq not ready"
  end

  def self.deploy_worker(queue)
    `aws ecs run-task --cluster #{@cluster_name} --network-configuration "awsvpcConfiguration={subnets=[#{@subnets}],securityGroups=[#{@security_group}],assignPublicIp='ENABLED'}" --launch-type FARGATE --started-by PPGWorkerHandler --task-definition #{@task_definition} --region $AWS_REGION`
  end
end