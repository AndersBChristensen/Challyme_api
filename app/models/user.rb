class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :invites
	has_many :challenges
	has_many :friends
	accepts_nested_attributes_for :challenges
	accepts_nested_attributes_for :invites
	accepts_nested_attributes_for :friends


	def friend_status?(myId, userId)
			if Friend.where(friend_one_id: myId, friend_two_id: userId).count > 0
				status = true
			elsif Friend.where(friend_two_id: myId, friend_one_id: userId).count > 0
				status = true
    	else
				status = false
			end
			status
	end


end
