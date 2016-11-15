class UserPoint < ActiveRecord::Base

  belongs_to :user

  def give_point(point_type, user_id)

    add_point = UserPoint.create({user_id: user_id, point_type: point_type})

    add_point

  end


end
