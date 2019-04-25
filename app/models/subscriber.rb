class Subscriber < ApplicationRecord
  self.primary_key = 'one_signal_uuid'
  belongs_to :user
end
