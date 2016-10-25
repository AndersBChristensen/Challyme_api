class AddProfileImageAndCoverImage < ActiveRecord::Migration
  def change
    add_column :users, :profileimage, :string
    add_column :users, :coverimage, :string
  end
end
