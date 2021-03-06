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

		# Find the users invite to find the challenge_id.
		@invite = Invite.find(invite_id)

		#Use the challenge_id from the users invite to find out if there are other invites with the same challenge id.
		if Invite.where(challenge_id: @invite.challenge_id).count > 1
			status = true
		else
			status = false
		end
		status
	end

	def validateID?(invite_id, task_date_id)
		if Complete.where(id: invite_id, task_date_id: task_date_id).count > 0
			status = true
		else
			status = false
		end
		status
	end

	def completionResult?(invite_id, task_date_id)
		if Complete.where(id: invite_id, task_date_id: task_date_id).count > 0

			if Complete.where(id: invite_id, task_date_id: task_date_id).first!.distance != nil && Complete.where(id: invite_id, task_date_id: task_date_id).first!.time == nil
				  status = Complete.where(id: invite_id, task_date_id: task_date_id).first!.distance
			end

			if Complete.where(id: invite_id, task_date_id: task_date_id).first!.time != nil  && Complete.where(id: invite_id, task_date_id: task_date_id).first!.distance == nil
					 status = Complete.where(id: invite_id, task_date_id: task_date_id).first!.time
			end

		else
			status = 0
		end
		status
	end

end
