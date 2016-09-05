class Action < ActiveRecord::Base
	belongs_to :task
	has_many :action_dates
	accepts_nested_attributes_for :action_dates

	def as_json(options = {})
		{
				id: self.id,
				name: self.name,
				action_dates: self.action_dates
		}
	end

end
