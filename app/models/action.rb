class Action < ActiveRecord::Base
	belongs_to :task
	has_one :actionmodule
	accepts_nested_attributes_for :actionmodule


	def as_json(options = {})
		{
				id: self.id,
				name: self.name,
				actionmodule: self.actionmodule
		}
	end

	def action_module_type(action_id)
		type = ''
		if Action.find(action_id).present?
			@action = Action.find(action_id)
			if @action.actionmodule.present?
				type = @action.actionmodule.moduletype
				puts type.inspect
			end
		end
		type
	end

	def action_module_time(action_id)
		type = 0
		if Action.find(action_id).present?
			@action = Action.find(action_id)
			if @action.actionmodule.present?
				type = @action.actionmodule.time
			end
		end
		type
	end

	def task_name_for_action(task_id)

		task_name = ''

		if Task.find_by_id(task_id).present?

			task_name = Task.find(task_id).title

		end
		task_name

	end

	def invite_id(challenge_id)

		c_id = 0

		if Challenge.find(challenge_id).present?
			@challenge = Challenge.find(challenge_id)

				if Invite.find_by_challenge_id(@challenge.id).present?
					@invite = Invite.find_by_challenge_id(@challenge.id)
					c_id = @invite.id
				end
		end
		c_id
	end

	def invite_user_id(challenge_id)
		u_id = 0

		if Challenge.find(challenge_id).present?
			@challenge = Challenge.find(challenge_id)

			if Invite.find_by_challenge_id(@challenge.id).present?
				@invite = Invite.find_by_challenge_id(@challenge.id)
				u_id = @invite.user_id
			end
		end
		u_id
	end

	def complete_status(invite_id, task_date_id)

		status = nil



		if Complete.find_by_invite_id(invite_id).present? && Complete.find_by_task_date_id(task_date_id).present?
			status = true
		else
			if TaskDate.find(task_date_id).date >= Date.today
				status = nil
			else
				status = false
			end	
		end

		puts status.inspect
		puts invite_id.inspect
		puts task_date_id.inspect
		status

	end


end
