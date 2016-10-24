class Api::ActivitiesController < ApplicationController

  before_action :doorkeeper_authorize!, except: [] #Todo sæt tilbage til at have oauth
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def get_activities
    @activities = User.find(doorkeeper_token.resource_owner_id).activities.order('created_at DESC')
    @user = User.find(doorkeeper_token.resource_owner_id)
    render json: @activities.map {|activity|
      {
        username: @user.username,
        user_id: activity.user_id,
        activity_type: activity.activity_type,
        activity_id: activity.activity_id
      }
    }
  end

end
