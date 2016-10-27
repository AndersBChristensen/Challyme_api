class Api::FollowersController < ApplicationController
  before_action :doorkeeper_authorize!, except: [] #Todo sæt tilbage til at have oauth
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


  def index
    followers = Follower.all
    render json:followers
  end

  def create
    param = params.permit(:follower_one_id, :follower_two_id, :status)
    follower = Follower.create(param)
    if follower
      Activity.add_activity(doorkeeper_token.resource_owner_id, 'started_following', follower.id)
      render status: :created, json: follower
    else
      render :status => 400
    end
  end

  def destroy
    @follower = Follower.find_by(follower_one_id: doorkeeper_token.resource_owner_id, follower_two_id: params[:id])
    Activity.add_activity(doorkeeper_token.resource_owner_id, 'stopped_following', @follower.follower_two_id)
    @follower.destroy
    render json: :deleted
  end

  def update
    follower = Follower.find_by(follower_one_id: params[:id], follower_two_id: doorkeeper_token.resource_owner_id)
    p = params.permit(:status)

    respond_to do |format|
      if follower.update(p)
        #invite.save
        format.json { render :status => :updated, :json => follower }
      else
        format.json { render :status => 400 }
      end
    end
  end

  # 'friendOne.profileimage.url(:thumb)'

  def followers
    @followers = Follower
                     .select('friendOne.username as username', 'friendOne.first_name as firstname', 'friendOne.last_name as lastname', 'friendOne.id as user_id', 'friendOne.' +  profileimage.url(:thumb))
                     .joins("left join users as friendOne on followers.follower_one_id = friendOne.id")
                     .joins("left join users as friendTwo on followers.follower_two_id = friendTwo.id")
                     .where(follower_two_id: params[:id])

    render json: @followers
  end

  def follows
    @follows = Follower
                   .select('friendTwo.username as username', 'friendTwo.first_name as firstname', 'friendTwo.last_name as lastname', 'friendTwo.id as user_id' )
                   .joins("left join users as friendOne on followers.follower_one_id = friendOne.id")
                   .joins("left join users as friendTwo on followers.follower_two_id = friendTwo.id")
                   .where(follower_one_id: params[:id])

    render json: @follows
  end

  def followRequest
    followRequest = Follower
                        .select('followers.id','friendOne.username as follower_1', 'friendTwo.username as follower_2', 'followers.status')
                        .joins("left join users as friendOne on followers.follower_one_id = friendOne.id")
                        .joins("left join users as friendTwo on followers.follower_two_id = friendTwo.id")
                        .where(status: 0)
                        .where(friend_two_id: doorkeeper_token.resource_owner_id)

    render json:  followRequest
  end

  def followers_1
    followers = Follower
                  .select('followers.id','friendOne.username as follower_1', 'friendTwo.username as follower_2', 'followers.status')
                  .joins("left join users as friendOne on followers.follower_one_id = friendOne.id")
                  .joins("left join users as friendTwo on followers.follower_two_id = friendTwo.id")
                  .where(status: 1)
                  .where("follower_one_id =" +  doorkeeper_token.resource_owner_id + " OR follower_two_id = " + doorkeeper_token.resource_owner_id)

    render json:  followers
  end
end
