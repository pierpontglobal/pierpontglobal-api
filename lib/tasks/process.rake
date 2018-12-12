# frozen_string_literal: true

namespace :process do
  desc 'Verifies if sidekiq process is running'
  task :running do
    pid = `ps aux | grep -i [s]idekiq | awk '{print $2}'`.to_i
    pid = pid.zero? ? 999_999 : pid
    Process.kill(0, pid)
  end
end
