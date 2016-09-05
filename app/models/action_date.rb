class ActionDate < ActiveRecord::Base
  belongs_to :action
  has_many :completes

  def as_json(options = {})
    {
        id: self.id,
        date: self.date
    }
  end

end
