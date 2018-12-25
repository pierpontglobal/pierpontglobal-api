class StepLog < ApplicationRecord
  belongs_to :step_group
  belongs_to :adquisition
  has_many :file_attachments, as: :owner
end
