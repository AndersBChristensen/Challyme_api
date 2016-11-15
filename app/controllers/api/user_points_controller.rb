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

  def total_points

    @p = params.permit(:user_id)

    @points = UserPoint.where(user_id: @p[:user_id]).count

    if @points
      render json: @points
    else
      render :status => 400, json: 0
    end

  end

end
