class CreateRelevantUsers < ActiveRecord::Migration
  def change
    create_table :activities_users, id: false do |t|
      t.integer :activity_id
      t.integer :user_id
      t.timestamps null: false
    end
    add_index :activities_users, :activity_id
    add_index :activities_users, :user_id
  end
end
