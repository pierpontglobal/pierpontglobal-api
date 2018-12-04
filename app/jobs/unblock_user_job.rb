class UnblockUserJob
  include Sidekiq::Worker
  def perform(*args)
    args.each do |user_info|
      user = ::User.find(user_info["id"])
      user.reset_try_count
    end
  end
end