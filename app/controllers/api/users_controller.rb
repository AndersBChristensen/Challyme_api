class Api::UsersController < ApplicationController
  before_action :doorkeeper_authorize!, except: [:create, :user_challenges]
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	skip_before_action :verify_authenticity_token


	def index
		users = User.find(doorkeeper_token.resource_owner_id)
		render json:users
	end

	def show
		@user = User.find(params[:id])
		render json: User
	end

	def create
		param = params.require(:user).permit(:first_name, :last_name, :username, :gender, :password, :created_at, :updated_at, :active, :phone, :email, :birthday)
		user = User.create(param)
		if user
			render status: :created, json: user
		else
			render :status => 400 
		end
	end

	def update
		respond_to do |format|
			if user.update(user_params)
				render :status => :updated, :json => user
			else
				render :status => 400
			end
		end
	end

	def destroy
		user.destroy
		respond_to do |format|
			msg = { :status => "ok", :message => "success", :html => "<b>...</b>" }
    		format.json  { render :json => msg }
    	end
	end

	def user_challenges 
		user = User.find(params[:id])
		
		render json: {
			id: user.id,
			first_name: user.first_name,
			last_name: user.last_name,
			challenges: user.challenges
		}
	end

	def user_score

		#TODO count all

		@actions = Action.includes(:task).where(tasks: {challenge_id: self.id}).count

	end

	def search_users

		@key = "%#{params[:key]}%"
		@columns = %w{first_name last_name username}
		@users = User.where(
				@columns
						.map {|c| "#{c} like :search" }
						.join(' OR '),
				search: @key
		).limit(50)

		render json: @users.map {|user|
			{
					id: user.id,
					username: user.username,
					firstname: user.first_name,
					lastname: user.last_name,
					friend_status: user.friend_status?(doorkeeper_token.resource_owner_id, user.id),
					follower_status: user.follower_status?(doorkeeper_token.resource_owner_id, user.id),
					follows: user.who_i_follow(user.id),
					follows_user: user.who_follow_me(user.id),
					total_friends: user.total_friends(user.id),
					pending_friend_status: user.pending_friend_status?(doorkeeper_token.resource_owner_id, user.id)
			}
		}

	end

	def user_stats
		@users = User.find(params[:id])

		render json: @users.map {|user|
				{
						friend_status: user.friend_status?(doorkeeper_token.resource_owner_id, user.id),
						follower_status: user.follower_status?(doorkeeper_token.resource_owner_id, user.id),
						follows: user.who_i_follow(user.id),
						follows_user: user.who_follow_me(user.id),
						total_friends: user.total_friends(user.id),
						pending_friend_status: user.pending_friend_status?(doorkeeper_token.resource_owner_id, user.id)
				}
		}

	end

	private
		def set_user
			user = User.find(params[:id])
			render json: user
		end
		def user_params
      		params.require(:user).permit(:first_name, :last_name, :username, :gender)
    	end
end
