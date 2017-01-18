class Invite < ActiveRecord::Base
	belongs_to :user
	belongs_to :challenge
	has_many :completes

	def as_json(options = {})
		{
				id: self.id,
				accepted: self.accepted,
				challenge: self.challenge,
				user: self.user
		}
	end


  def self.all_actions_for_user(user_id)
		# all.includes(challenge: {tasks: :actions, tasks: task_dates}).includes(user: :actions).where('invites.user_id' => 3)
		where(user_id: user_id, accepted: true)
				.includes(challenge: {tasks: :actions, tasks: :task_dates})
				.includes(:user)
				.includes(:completes)
	end

	def otherUsers?(invite_id)
		invite = Invite.find(invite_id)
		if Invite.where(challenge_id: invite.challenge_id).count > 1
			status = true
		else
			status = false
		end
		status
	end

end
