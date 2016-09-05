class Invite < ActiveRecord::Base
	belongs_to :user
	belongs_to :challenge
	has_many :completes
end
