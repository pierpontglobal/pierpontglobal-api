# frozen_string_literal: true
include Rails.application.routes.url_helpers

# Dealers definition model
class Dealer < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :user
  has_one_attached :dealer_logo

  def sanitized
    {
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        phone_number: phone_number,
        logo_url: dealer_logo.attached? ? rails_blob_path(dealer_logo, disposition: "attachment", only_path: true) : nil,
    }
  end
end
