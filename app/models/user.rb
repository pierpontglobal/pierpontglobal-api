# frozen_string_literal: true

require 'sendgrid-ruby'
class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :email, presence: true, on: :create
  validates :phone_number, presence: true, on: :create

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  after_create :assign_default_role
  after_find :assign_default_role
  rolify # Allow handling of user roles in the application

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: ::JwtBlacklist

  has_many :risk_notices, dependent: :destroy
  has_one :dealer, dependent: :destroy
  has_many :funds
  has_many :bids

  has_many :notifications
  has_many :subscribers

  has_many :user_saved_cars, dependent: :destroy
  has_many :cars, through: :user_saved_cars

  has_one_attached :profile_picture

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def sanitized_for_admin
    {
      id: id,
      name: first_name || 'Not available',
      lastName: last_name || 'Not Available',
      avatar: 'https://avatars.servers.getgo.com/2205256774854474505_medium.jpg',
      nickname: username,
      company: dealer.try(:name) || 'Not created',
      email: email,
      phone: phone_number,
      address: primary_address,
      birthday: '',
      notes: ''
    }
  end

  def send_reset_email
    token = generate_token
    update!(reset_password_token: token, reset_password_sent_at: Time.now)
    reset_template = load_reset_template(token)
    data = JSON.parse(reset_template.to_json)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.mail._('send').post(request_body: data)
  end

  def load_reset_template(token)
    { personalizations: [
        {
            to: [email: email],
            dynamic_template_data: {
                "callback": Rails.env.production? ? "https://app.pierpontglobal.com/reset_password" : "http://0.0.0.0:4000/reset_password",
                "token": token
            }
        }
    ], from: { email: ENV['SOURCE_EMAIL'] },
      template_id: 'd-16b03d18163947a7b7cb79a102024f2b' }
  end

  def sanitized
    dealer = ::Dealer.find_by(:user_id => id)
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
      roles: roles.map(&:name),
      require_2fa: require_2fa,
      phone_number_validated: phone_number_validated,
      last_sign_in_at: current_sign_in_at,
      last_sign_in_ip: current_sign_in_ip.to_s,
      photo_url: profile_picture.attached? ? rails_blob_path(profile_picture, disposition: "attachment", only_path: true) : nil,
      dealer: dealer.present? ? dealer.sanitized : nil
    }
  end

  def send_payment_status
    ::UserMailer.new.send_payment_status(self)
  end

  def set_risk_status(risk_id, status)
    risk_notice = risk_notices.where(id: risk_id).first
    risk_notice.status = status
    risk_notice.save!
    risk_notice
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

  def unlock
    self.verified = true
    save!
  end

  def lock
    self.verified = false
    save!
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

  def invalidate_session!
    access_tokens.each(&:destroy!)
  end

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def fund
    funds.last
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def append_condition(status, reason)
    status[:status] = false
    status[:reason] << reason
  end

  protected

  def generate_token
    token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(reset_password_token: random_token)
    end
    token
  end
end
