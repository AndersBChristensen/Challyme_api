class Api::FriendsController < ApplicationController

  before_action :doorkeeper_authorize!, except: [] #Todo sæt tilbage til at have oauth
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


  def index
    friends = Friend.all
    render json:friends
  end

  def destroy
    @friend = Friend.find_by(friend_one_id: doorkeeper_token.resource_owner_id, friend_two_id: params[:id])
    Activity.add_activity(doorkeeper_token.resource_owner_id, 'removed_friend_request', @friend.friend_two_id)
    @friend.destroy
    render json: :deleted
  end

  def create
    param = params.permit(:friend_one_id, :friend_two_id, :status)
    friend = Friend.create(param)
    Activity.add_activity(doorkeeper_token.resource_owner_id, 'friend_request', friend.id)
    if friend
      render status: :created, json: friend
    else
      render :status => 400
    end
  end

  def update
    friend = Friend.find_by(friend_one_id: params[:id], friend_two_id: doorkeeper_token.resource_owner_id)
    p = params.permit(:status)

    respond_to do |format|
      if friend.update(p)
        #invite.save
        Activity.add_activity(doorkeeper_token.resource_owner_id, 'accepted_friend_request', friend.id)
        format.json { render :status => :updated, :json => friend }
      else
        format.json { render :status => 400 }
      end
    end
  end

  def decline_friendship
    @friend = Friend.find_by(friend_one_id: params[:id], friend_two_id: doorkeeper_token.resource_owner_id)
    Activity.add_activity(doorkeeper_token.resource_owner_id, 'declined_friend', @friend.friend_one_id)
    @friend.destroy
    render json: :deleted
  end

  def friends
    @friends = Follower.select('friendTwo.username as username', 'friendTwo.first_name as firstname', 'friendTwo.last_name as lastname', 'friendTwo.id as user_id' )
                   .joins("left join users as friendOne on friends.friend_one_id = friendOne.id")
                   .joins("left join users as friendTwo on friends.friend_two_id = friendTwo.id")
                   .where("friend_one_id =" +  params[:id] + " OR friend_two_id = " + params[:id])

    render json: @friends

  end

  def friendRequests
    friendRequest = Friend
                        .select('friends.id','friendOne.username as friend_1', 'friendTwo.username as friend_2', 'friends.status')
                        .joins("left join users as friendOne on friends.friend_one_id = friendOne.id")
                        .joins("left join users as friendTwo on friends.friend_two_id = friendTwo.id")
                        .where(status: 0)
                        .where(friend_two_id: doorkeeper_token.resource_owner_id)

    render json:  friendRequest
  end

  def friends1
    friends = Friend
                        .select('friends.id','friendOne.username as friend_1', 'friendTwo.username as friend_2', 'friends.status')
                        .joins("left join users as friendOne on friends.friend_one_id = friendOne.id")
                        .joins("left join users as friendTwo on friends.friend_two_id = friendTwo.id")
                        .where(status: 1)
                        .where("friend_one_id =" +  doorkeeper_token.resource_owner_id + " OR friend_two_id = " + doorkeeper_token.resource_owner_id)

    render json:  friends
  end

  def show_friends

    @p = params.permit(:id)

    @friends = Friend.where(status: 1).where('friend_one_id = :val1 OR friend_two_id = :val2', val1: @p[:id], val2: @p[:id])

    dk_id = @p[:id]

    if @friends.count > 0
      render json: @friends.map  {|friend|
        {
            id: friend.friend_id(friend.friend_one_id, friend.friend_two_id, dk_id),
            username: User.find(friend.friend_id(friend.friend_one_id, friend.friend_two_id, dk_id)).username,
            firstname: User.find(friend.friend_id(friend.friend_one_id, friend.friend_two_id, dk_id)).first_name,
            lastname: User.find(friend.friend_id(friend.friend_one_id, friend.friend_two_id, dk_id)).last_name,
            profile_image: User.find(friend.friend_id(friend.friend_one_id, friend.friend_two_id, dk_id)).profileimage.url(:medium)
        }
      }
    else
      render json: []
    end

  end

end
