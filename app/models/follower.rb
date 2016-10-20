class Follower < ActiveRecord::Base
  belongs_to :follower_one, :class_name => 'User'
  belongs_to :follower_one, :class_name => 'User'
  belongs_to :user
end
