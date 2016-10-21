class Api::FollowersController < ApplicationController
  before_action :doorkeeper_authorize!, except: [:followers, :follows] #Todo sæt tilbage til at have oauth
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
      render status: :created, json: follower
    else
      render :status => 400
    end
  end

  def destroy
    @follower = Follower.find_by(follower_one_id: doorkeeper_token.resource_owner_id, follower_two_id: params[:id])
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

  def followers
    @followers = Follower
                     .select('followers.id as followers_id','friendTwo.username as username', 'friendTwo.first_name as firstname', 'friendTwo.last_name as lastname', 'friendTwo.id as id' )
                     .joins("left join users as friendOne on followers.follower_one_id = friendOne.id")
                     .joins("left join users as friendTwo on followers.follower_two_id = friendTwo.id")
                     .where(follower_two_id: params[:id])

    render json: @followers
  end

  def follows
    @follows = Follower.where(follower_one_id: params[:id])

    render json: @follows.map {|follow|
      {
          id: User.user_id?(follow.follower_one_id),
          username: User.username?(follow.follower_one_id),
          firstname: User.firstname?(follow.follower_one_id),
          lastname: User.lastname?(follow.follower_one_id)
      }
    }
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
