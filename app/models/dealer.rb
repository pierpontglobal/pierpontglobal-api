# frozen_string_literal: true

# Dealers definition model
class Dealer < ApplicationRecord
  belongs_to :user
end
