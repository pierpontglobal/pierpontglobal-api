# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :device_identifier

    def connect
      self.current_user = auth_user
      self.device_identifier = request.params[:hash]
    end

    private

    def auth_user
      token = request.params[:token]
      access_token = Doorkeeper::AccessToken.find_by(token: token)
      User.find(access_token.resource_owner_id) if access_token
    end
  end
end
