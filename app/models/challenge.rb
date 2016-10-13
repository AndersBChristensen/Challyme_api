class Challenge < ActiveRecord::Base
  has_many :invites
  has_many :users, through: :invites
  belongs_to :user #lav alias creator
  has_many :tasks
  accepts_nested_attributes_for :tasks

  def totals
    total_dates = TaskDate.includes(:task).where(tasks: {challenge_id: self.id}).count
    total_actions = Action.includes(:task).where(tasks: {challenge_id: self.id}).count
    total_dates * total_actions
  end

  def as_json(options = {})
  	{
  		id: self.id,
  		title: self.title,
  		prize: self.prize,
      status: self.status,
  		tasks: self.tasks
  	}
  end
end
