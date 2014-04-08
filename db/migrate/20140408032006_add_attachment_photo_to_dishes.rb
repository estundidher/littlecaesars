class AddAttachmentPhotoToDishes < ActiveRecord::Migration
  def self.up
    change_table :dishes do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :dishes, :photo
  end
end