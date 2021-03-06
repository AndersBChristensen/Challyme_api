class Api::UsersController < ApplicationController
  before_action :doorkeeper_authorize!, except: [:create, :user_challenges, :new]
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

	def new
		@user = User.new
	end

	def create
		param = params.require(:user).permit(:first_name, :last_name, :username, :gender, :password, :created_at, :updated_at, :active, :phone, :email, :birthday, :weight)
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
					profileimage: user.profileimage.url(:thumb),
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

		@user = User.where(id: params[:id])

		render json: @user.map {|user|
				{
						friend_status: user.friend_status?(doorkeeper_token.resource_owner_id, user.id),
						follower_status: user.follower_status?(doorkeeper_token.resource_owner_id, user.id),
						follows: user.who_i_follow(user.id),
						follows_user: user.who_follow_me(user.id),
						total_friends: user.total_friends(user.id),
						pending_friend_status: user.pending_friend_status?(doorkeeper_token.resource_owner_id, user.id),
						points: user.get_total_points(user.id)
				}
		}

	end

	def news

		@user = User.find(params[:id])

		@news = @user.challenges.tasks.actions

		render json: @news
	end

	def profile_image_medium_url

		@user = User.find(params[:id])

		@url = @user.profileimage.url(:medium)

		render json: @url
	end

	def cover_image_medium_url

		@user = User.find(params[:id])

		@url = @user.coverimage.url(:medium)

		render json: @url
	end

	def upload_profile_image
		@p = params.permit(:image_data, :id)
		if User.exists?(id: @p[:id])

			@user = User.find(@p[:id])

			image_data = @p[:image_data]

			respond_to do |format|
				if @user.update_attributes(profileimage: image_data)
					Activity.add_activity(doorkeeper_token.resource_owner_id, 'uploaded_new_profile_image', @user.id)
					format.json { render :status => :ok, json: :updated }
				else
					format.json { render :status => 400 }
				end
			end
		end
	end

	def upload_cover_image
		@p = params.permit(:image_data, :id)
		if User.exists?(id: @p[:id])

			@user = User.find(@p[:id])

			image_data = @p[:image_data]

			respond_to do |format|
				if @user.update_attributes(coverimage: image_data)
					Activity.add_activity(doorkeeper_token.resource_owner_id, 'uploaded_new_cover_image', @user.id)
					format.json { render :status => :ok, json: :updated }
				else
					format.json { render :status => 400 }
				end
			end
		end
	end

	def remove_profile_image
		@user = User.find(params[:id])

		@user.profileimage = nil

		if @user.save
			render :status => :created, :json => @user
		else
			render :status => 400, json: []
		end
	end

	def remove_cover_image
		@user = User.find(params[:id])

		@user.coverimage = nil

		if @user.save
			render :status => :created, :json => @user
		else
			render :status => 400, json: []
		end
	end

	def otherUsersForActions
    @p = params.permit(:invite_id, :task_date_id)
		@invite = Invite.find(params[:invite_id])
		@invites = Invite.where(challenge_id: @invite.challenge_id).where("id NOT IN (?)", @invite.id)

		render json: @invites.map {|invite| {
				user_id: User.find(invite.user_id).id,
				username: User.find(invite.user_id).username,
        profileimage: User.find(invite.user_id).profileimage.url(:medium),
				completed: invite.validateID?(invite.id, @p[:task_date_id]),
        completed_result: invite.completionResult?(invite.id, @p[:task_date_id])
			}
		}

	end

	private
		def set_user
			user = User.find(params[:id])
			render json: user
		end
		def user_params
      		params.require(:user).permit(:first_name, :last_name, :username, :gender, :profileimage, :coverimage, :weight)
    	end
end
