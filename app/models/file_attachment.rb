class FileAttachment < ApplicationRecord
  belongs_to :owner, polymorphic: true

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\A*\/.*\z/

end
