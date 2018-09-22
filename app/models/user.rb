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

end
