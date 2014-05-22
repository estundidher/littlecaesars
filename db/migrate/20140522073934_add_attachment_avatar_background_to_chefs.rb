class AddAttachmentAvatarBackgroundToChefs < ActiveRecord::Migration
  def self.up
    change_table :chefs do |t|
      t.attachment :avatar
      t.attachment :background
    end
  end

  def self.down
    drop_attached_file :chefs, :avatar
    drop_attached_file :chefs, :background
  end
end