class Friend < ActiveRecord::Base
  belongs_to :friend_one, :class_name => 'User'
  belongs_to :friend_two, :class_name => 'User'
  belongs_to :user
  has_many :activities
end
