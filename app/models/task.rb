class Task < ActiveRecord::Base
	belongs_to :challenge
  	has_many :actions
		has_many :action_dates
  	accepts_nested_attributes_for :actions
		accepts_nested_attributes_for :action_dates


	def as_json(options = {})
  	{
  		id: self.id,
  		title: self.title,
  		actions: self.actions,
			action_dates: self.action_dates
  	}
  	end
end
