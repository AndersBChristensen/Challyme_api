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

end
