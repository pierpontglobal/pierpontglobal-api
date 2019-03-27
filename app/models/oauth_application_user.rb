class OauthApplicationUser < ApplicationRecord
  belongs_to :application_oath
  belongs_to :user
  has_secure_token :token
  before_create :set_initial_state

  def set_initial_state
    self.active = true
  end

end
