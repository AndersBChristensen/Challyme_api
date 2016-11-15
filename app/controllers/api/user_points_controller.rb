class Api::UserPointsController < ApplicationController

  before_action :doorkeeper_authorize!, except: []
  skip_before_action :verify_authenticity_token
  before_action :set_user_points, only: [:show, :edit, :destroy]

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

  private
    def set_user_points
      user_point = UserPoint.find(params[:id])

      render json: user_point
    end
end
