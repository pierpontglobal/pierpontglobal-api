class Fund < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true
end
