# frozen_string_literal: true

# Manages the background task for admin
class VerificationChannel < ApplicationCable::Channel

  def subscribe; end

  def subscribed
    stream_from "verification_channel_#{device_identifier}"
  end

  def unsubscribe; end
end
