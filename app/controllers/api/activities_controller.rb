class Api::ActivitiesController < ApplicationController

  before_action :doorkeeper_authorize!, except: [:get_activities] #Todo sæt tilbage til at have oauth
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def get_activities
    @activities = Activity.find_by(user_id: params[:id])
    render json: @activities
  end

end
