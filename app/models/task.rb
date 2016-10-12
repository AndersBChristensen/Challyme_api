class Task < ActiveRecord::Base
	belongs_to :challenge
  	has_many :actions
		has_many :task_dates
  	accepts_nested_attributes_for :actions
		accepts_nested_attributes_for :task_dates


	def as_json(options = {})
  	{
  		id: self.id,
  		title: self.title,
  		actions: self.actions,
			task_dates: self.task_dates
  	}
  	end
end
