module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = User.all.first
    end

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

  end
end
