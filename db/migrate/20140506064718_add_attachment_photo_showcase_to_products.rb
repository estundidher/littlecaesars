class AddAttachmentPhotoShowcaseToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.attachment :photo_showcase
    end
  end

  def self.down
    drop_attached_file :products, :photo_showcase
  end
end