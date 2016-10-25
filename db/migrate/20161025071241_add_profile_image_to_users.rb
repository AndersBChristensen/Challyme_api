class AddProfileImageToUsers < ActiveRecord::Migration
  def up
    add_attachment :users, :profileimage
  end

  def down
    remove_attachment :users, :profileimage
  end
end
