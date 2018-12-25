class CreateFileAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :file_attachments do |t|
      t.references :owner, polymorphic: true

      t.timestamps
    end
  end
end
