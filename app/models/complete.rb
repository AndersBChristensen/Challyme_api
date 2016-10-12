class Complete < ActiveRecord::Base
	belongs_to :task_date
  belongs_to :invite
end
