class Actionmodule < ActiveRecord::Base
  belongs_to :action

  def as_json(options = {})
    {
        id: self.id,
        countertype: self.countertype,
        countertime: self.countertime,
        text: self.text
    }
  end
end
