class Complete < ActiveRecord::Base

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	belongs_to :task_date
  belongs_to :invite

  def as_json(options = {})
    {
        id: self.id,
        invite_id: self.invite_id,
        task_date: self.task_date,
        image: self.image,
        moduletype: self.moduletype,
        time: self.time,
        distance: self.distance
    }
  end

end
