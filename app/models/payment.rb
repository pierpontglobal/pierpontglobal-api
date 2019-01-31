class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :verify_by, class_name: :User, optional: true
end
