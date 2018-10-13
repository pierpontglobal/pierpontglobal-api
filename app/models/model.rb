class Model < ApplicationRecord
  belongs_to :maker, optional: true
end
