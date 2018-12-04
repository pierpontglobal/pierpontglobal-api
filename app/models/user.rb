# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, on: :create
  validates :phone_number, presence: true, on: :create

  rolify

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  has_many :risk_notices

  def sanitized
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      username: username,
      phone_number: phone_number,
      address: {
        country: country,
        city: city,
        zip_code: zip_code,
        primary_address: primary_address,
        secondary_address: secondary_address
      },
      verified: verified,
      roles: roles,
      require_2fa: require_2fa,
      phone_number_validated: phone_number_validated
    }
  end

  def try_count
    attempts = failed_attempts
    self.failed_attempts = attempts + 1
    save!
    attempts + 1
  end

  def reset_try_count
    self.failed_attempts = 0
    save!
    0
  end

  def active?
    status = {
      status: true,
      reason: []
    }

    append_condition(status, ::TEXT_RESPONSE[:not_verified]) unless verified
    append_condition(status, ::TEXT_RESPONSE[:not_confirmed]) if confirmed_at.nil?
    append_condition(status, ::TEXT_RESPONSE[:high_risk]) unless risk_notices.empty?

    status
  end

  private

  def append_condition(status, reason)
    status[:status] = false
    status[:reason] << reason
  end
end
