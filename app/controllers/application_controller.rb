class ApplicationController < ActionController::API

  before_action :doorkeeper_authorize!
  respond_to :json

  private

  # Doorkeeper methods
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end
