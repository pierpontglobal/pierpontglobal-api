class ApplicationController < ActionController::API

  before_action :doorkeeper_authorize!
  before_action :current_resource_owner
  respond_to :json

  private

  # Doorkeeper methods
  def current_resource_owner
    @user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end
