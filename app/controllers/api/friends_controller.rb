class Api::FriendsController < ApplicationController

  before_action :doorkeeper_authorize!, except: [] #Todo sæt tilbage til at have oauth
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


  def index
    friends = Friend.all
    render json:friends
  end

  def create
    param = params.require(:friend).permit(:friend_one_id, :friend_two_id, :status)
    friend = Friend.create(param)
    if friend
      render status: :created, json: friend
    else
      render :status => 400
    end
  end

  def update
    friend = Friend.find(params[:id])
    p = params.require(:friend).permit(:status)

    respond_to do |format|
      if friend.update(p)
        #invite.save
        format.json { render :status => :updated, :json => friend }
      else
        format.json { render :status => 400 }
      end
    end
  end

  def friendRequests
    friendRequest = Friend
                        .select('friendOne.username as friend_1', 'friendTwo.username as friend_2', 'friends.status')
                        .joins("left join users as friendOne on friends.friend_one_id = friendOne.id")
                        .joins("left join users as friendTwo on friends.friend_two_id = friendTwo.id")
                        .where(status: 0)
                        .where(friend_two_id: doorkeeper_token.resource_owner_id)

    render json:  friendRequest
  end

  def friends
    friends = Friend
                        .select('friendOne.username as friend_1', 'friendTwo.username as friend_2', 'friends.status')
                        .joins("left join users as friendOne on friends.friend_one_id = friendOne.id")
                        .joins("left join users as friendTwo on friends.friend_two_id = friendTwo.id")
                        .where(status: 1)
                        .where("friend_one_id =" +  doorkeeper_token.resource_owner_id + " OR friend_two_id = " + doorkeeper_token.resource_owner_id)

    render json:  friends
  end

end
