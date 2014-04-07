class AddAttachmentAvatarToIngredients < ActiveRecord::Migration
  def self.up
    change_table :ingredients do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :ingredients, :avatar
  end
end