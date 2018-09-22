class Fund < ApplicationRecord
  belongs_to :user
  belongs_to :payment
end
