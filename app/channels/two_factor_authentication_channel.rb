# frozen_string_literal: true

class TwoFactorAuthenticationChannel < ApplicationCable::Channel

  def subscribed
    stream_from "two_factor_authentication_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def validate_code(params)
    phone_sections = current_user.phone_number.split '-'
    country_code = phone_sections[0]
    phone_number = phone_sections[1]
    code = params['code']

    if !phone_number || !country_code || !code
      p 'Missing fields'
      return
    end

    response = Authy::PhoneVerification.check(
      verification_code: code,
      country_code: country_code,
      phone_number: phone_number
    )

    ActionCable.server.broadcast "two_factor_authentication_channel_#{current_user.id}",
                                 status: response
  end

  def send_token
    phone_sections = current_user.phone_number.split '-'
    country_code = phone_sections[0]
    phone_number = phone_sections[1]
    via = params['via']

    if !phone_number || !country_code || !via
      p 'Missing fields'
      return
    end

    response = Authy::PhoneVerification.start(
      via: via,
      country_code: country_code,
      phone_number: phone_number
    )

    ActionCable.server.broadcast "two_factor_authentication_channel_#{current_user.id}",
                                 status: response
  end
end
