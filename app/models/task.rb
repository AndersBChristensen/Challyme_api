class Task < ActiveRecord::Base
	belongs_to :challenge
  	has_many :actions
  	accepts_nested_attributes_for :actions

  	def as_json(options = {})
  	{
  		id: self.id,
  		title: self.title,
  		actions: self.actions
  	}
  	end
end
