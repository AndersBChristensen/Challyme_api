class Actionmodule < ActiveRecord::Base
  belongs_to :action

  def as_json(options = {})
    {
        id: self.id,
        moduletype: self.moduletype,
        time: self.time,
        distance: self.distance
    }
  end
end
