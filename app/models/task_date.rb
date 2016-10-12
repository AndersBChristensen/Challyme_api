class TaskDate < ActiveRecord::Base
  belongs_to :task
  has_many :completes

  def as_json(options = {})
    {
        id: self.id,
        date: self.date
    }
  end

end
