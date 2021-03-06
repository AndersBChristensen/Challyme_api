class Api::ActivitiesController < ApplicationController

  before_action :doorkeeper_authorize!, except: [] #Todo sæt tilbage til at have oauth
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def get_activities
    @activities = User.find(doorkeeper_token.resource_owner_id).activities.where(feed_type: 0).order('created_at DESC')

    render json: @activities.map {|activity|
      {
        username: User.find(activity.user_id).username,
        profile_image: User.find(activity.user_id).profileimage.url(:thumb),
        user_id: activity.user_id,
        activity_type: activity.activity_type,
        activity_id: activity.activity_id,
        task_name: activity.task_name_for_activity(activity.activity_type, activity.activity_id),
        challenge_name: activity.challenge_title_for_activity(activity.activity_id)
      }
    }
  end

end
