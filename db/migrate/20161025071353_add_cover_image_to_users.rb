class AddCoverImageToUsers < ActiveRecord::Migration
  def change
    def up
      add_attachment :users, :coverimage
    end

    def down
      remove_attachment :users, :coverimage
    end
  end
end
