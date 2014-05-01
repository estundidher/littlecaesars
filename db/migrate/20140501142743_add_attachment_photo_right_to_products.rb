class AddAttachmentPhotoRightToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.attachment :photo_right
    end
  end

  def self.down
    drop_attached_file :products, :photo_right
  end
end