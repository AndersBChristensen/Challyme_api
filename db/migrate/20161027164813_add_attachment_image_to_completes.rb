class AddAttachmentImageToCompletes < ActiveRecord::Migration
  def self.up
    change_table :completes do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :completes, :image
  end
end
