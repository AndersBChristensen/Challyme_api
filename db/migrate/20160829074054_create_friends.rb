class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|

      t.integer :friend_one_id
      t.integer :friend_two_id
      t.integer :status

      t.timestamps null: false
    end
    add_index(:friends, :friend_one_id)
    add_index(:friends, :friend_two_id)
  end
end
