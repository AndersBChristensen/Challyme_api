class UserPoint < ActiveRecord::Base

  belongs_to :user

  def give_point(points_type, user_id)

    @point = UserPoint.create(points_type: points_type, user_id: user_id)

    if @point
      render :status => :created, :json => @point
    else
      render :status => 400, json: []
    end

  end


end
