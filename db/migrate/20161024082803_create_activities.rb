class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|

      t.integer :user_id #Who generated the activity
      t.string :activity_type #Is it a comment, completed or other activity
      t.integer :activity_id #What is the id of the activity
      t.timestamps null: false
    end
  end
end
