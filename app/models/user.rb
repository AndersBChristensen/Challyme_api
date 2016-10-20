class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :invites
	has_many :challenges
	has_many :friends
  has_many :followers
	accepts_nested_attributes_for :challenges
	accepts_nested_attributes_for :invites
	accepts_nested_attributes_for :friends
  accepts_nested_attributes_for :followers


	def friend_status?(myId, userId)
			if Friend.where(friend_one_id: myId, friend_two_id: userId, status: 1).count > 0
				status = true
			elsif Friend.where(friend_two_id: myId, friend_one_id: userId, status: 1).count > 0
				status = true
    	else
				status = false
			end
			status
	end

  def follower_status?(myId, userId)
    if Follower.where(follower_one_id: myId, follower_two_id: userId, status: 1).count > 0
      status = true
    else
      status = false
    end
    status
  end

  def who_follow_me(myId)
    total_followers = Follower.where(follower_two_id: myId).count
    total_followers
  end

  def total_friends(myId)
    friend1 = Friend.where(friend_one_id: myId,  status: 1).count
    friend2 = Friend.where(friend_two_id: myId, status: 1).count
    friend1 + friend2
  end

  def who_i_follow(myId)
    total_followers = Follower.where(follower_one_id: myId).count
    total_followers
  end

end
