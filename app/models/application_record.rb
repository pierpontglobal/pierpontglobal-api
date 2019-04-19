# frozen_string_literal: true

require 'ostruct'

# Base models class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
