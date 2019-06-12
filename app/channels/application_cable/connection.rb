# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :device_identifier

    def connect
      self.current_user = find_verified_user
      self.device_identifier = request.params[:hash]
    end

    private

    def find_verified_user # this checks whether a user is authenticated with devise
      a = cookies
      p a
      verified_user = User.find_by(id: cookies.signed['user.id'])
      if verified_user && cookies.signed['user.expires_at'] > Time.now
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
