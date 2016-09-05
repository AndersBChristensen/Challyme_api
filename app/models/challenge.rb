class Challenge < ActiveRecord::Base
  has_many :invites
  has_many :users, through: :invites
  belongs_to :user #lav alias creator
  has_many :tasks
  accepts_nested_attributes_for :tasks

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
