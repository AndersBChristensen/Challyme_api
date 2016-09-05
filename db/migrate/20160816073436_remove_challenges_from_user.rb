class RemoveChallengesFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :challenges_id
  end
end
