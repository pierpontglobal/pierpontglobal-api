# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, on: :create
  validates :phone_number, presence: true, on: :create

  rolify

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

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
      roles: roles
    }
  end
end