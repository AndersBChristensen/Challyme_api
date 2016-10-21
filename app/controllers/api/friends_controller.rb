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
    @friend.destroy
    render json: :deleted
  end

  def create
    param = params.permit(:friend_one_id, :friend_two_id, :status)
    friend = Friend.create(param)
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
        format.json { render :status => :updated, :json => friend }
      else
        format.json { render :status => 400 }
      end
    end
  end

  def decline_friendship
    @follower = Friend.find_by(friend_one_id: params[:id], friend_two_id: doorkeeper_token.resource_owner_id)
    @follower.destroy
    render json: :deleted
  end

  def friends
    @friends_col1 = Friend.where(friend_one_id: params[:id],  status: 1)
    @friends_col2 = Friend.where(friend_two_id: params[:id], status: 1)
    @friends = @friends_col1 + @friends_col2

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

end
