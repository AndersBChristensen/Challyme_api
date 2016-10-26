class Api::InvitesController < ApplicationController

	before_action :doorkeeper_authorize!, except: [:create]
	skip_before_action :verify_authenticity_token
	before_action :set_invite, only: [:show, :edit, :destroy]

	def index
		invites = Invite.all
		render json:invites
	end

	def show
	end

	def create
		invite = Invite.create(create_invite_params)
		if invite
			render :status => :created, :json => invite
		else
			render :status => 400, json: []
		end
	end

	def update
		invite = Invite.find(params[:id])
		p = params.permit(:accepted)

		respond_to do |format|
			if invite.update(p)
				#invite.save
				format.json { render :status => :updated, :json => invite }
			else
				format.json { render :status => 400 }
			end
		end
	end

	def destroy
		invite.destroy
		respond_to do |format|
			msg = { :status => "ok", :message => "success", :html => "<b>...</b>" }
    		format.json  { render :json => msg }
    	end
	end

	def showInviteWithChallengeName
		#
		# Getting all the invites the user haven't answered.
		#
		invites = Invite
									.select('invites.id', 'challenges.title', 'users.username as invited', 'users.id as invited_id', 'invited_by.username as invited_by', 'invited_by.id as invited_by_id', 'invites.accepted')
									.joins("inner join challenges on challenges.id = invites.challenge_id
													inner join users on invites.user_id = users.id
													left join users as invited_by on challenges.user_id = invited_by.id")
									.where(user_id: doorkeeper_token.resource_owner_id).where("accepted IS ?", nil).order('invites.created_at DESC')
		render json: invites
	end

	def showAcceptedChallenges
		#
		# Show all the accepted challenges for a user.
		#
		invites = Invite
									.select('invites.id', 'challenges.title', 'users.username as invited', 'users.id as invited_id', 'invited_by.username as invited_by', 'invited_by.id as invited_by_id', 'invites.accepted')
									.joins("inner join challenges on challenges.id = invites.challenge_id
		                     	inner join users on invites.user_id = users.id
		                     	left join users as invited_by on challenges.user_id = invited_by.id")
									.where(user_id: doorkeeper_token.resource_owner_id).where("accepted IS ?", true).order('invites.created_at DESC')
		render json:  invites
	end

	private
		def set_invite
			invite = Invite.find(params[:id])

			render json: invite
		end
		def invite_params
      		params.require(:invite).permit(:accepted)
		end
		def create_invite_params
				params.require(:invite).permit(:user_id, :challenge_id, :accepted)
		end
end
