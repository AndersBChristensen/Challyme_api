class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|

      t.integer :follower_one_id
      t.integer :follower_two_id
      t.integer :status

      t.timestamps null: false
    end
    add_index(:followers, :follower_one_id)
    add_index(:followers, :follower_two_id)
  end
end
