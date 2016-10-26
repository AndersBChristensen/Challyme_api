class Challenge < ActiveRecord::Base
  has_many :invites
  has_many :users, through: :invites
  belongs_to :user #lav alias creator
  has_many :tasks
  has_many :activities
  accepts_nested_attributes_for :tasks

  def totals

    total = 0;
    self.tasks.each do |t|
      count = t.task_dates.count * t.actions.count
      total = total + count
    end

    total
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
