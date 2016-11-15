class UserPoint < ActiveRecord::Base

  belongs_to :user

  def self.give_point(user_id, point_type)

    add_point = UserPoint.create({user_id: user_id, point_type: point_type})

    add_point

  end


end
