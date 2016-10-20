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

	def friend_status
		status = false
			if User.includes(:friends).where(friends: {friend_one_id: self.id, friends: {friend_two_id: doorkeeper_token.resource_owner_id}}).exists?
				status = true
			elsif User.includes(:friends).where(friends: {friend_one_id: self.id, friends: {friend_two_id: doorkeeper_token.resource_owner_id}}).exists?
				status = true
    	else
				status = false
			end
		status
	end


end
