class RiskNotice < ApplicationRecord
  belongs_to :user, optional: true
end
