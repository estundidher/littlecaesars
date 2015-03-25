class AddAttachmentPhotoLeftToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.attachment :photo_left
    end
  end

  def self.down
    drop_attached_file :products, :photo_left
  end
end