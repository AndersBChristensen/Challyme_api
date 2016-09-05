class AddChallengesToUser < ActiveRecord::Migration
  def change 
  	add_reference :users, :challenges, foreign_key: true
  end
end
