class AddAttachmentPhotoToPlaces < ActiveRecord::Migration
  def self.up
    change_table :places do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :places, :photo
  end
end