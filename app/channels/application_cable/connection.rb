module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      user_id = request.params['user_id']
      puts "User authenticating with id: #{user_id}"
      logger.info "User authenticating with id: #{user_id}"
      self.current_user = User.find(user_id)
    end

  end
end
