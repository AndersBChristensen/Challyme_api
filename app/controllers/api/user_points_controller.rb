class Api::UserPointsController < ApplicationController

  def create

    @p = params.permit(:points_type, :user_id)
    @point = UserPoint.create(@p)

    if @point
      render :status => :created, :json => @point
    else
      render :status => 400, json: []
    end
  end

end
