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

		p = params.permit(:accepted, :id)

		invite = Invite.find(p[:id])

		puts(p[:accepted])

		if p[:accepted] == 'true'
			Activity.add_activity(doorkeeper_token.resource_owner_id, 'accepted_challenge', invite.id)
		elsif p[:accepted] == 'false'
			Activity.add_activity(doorkeeper_token.resource_owner_id, 'declined_challenge', invite.id)
		end

		respond_to do |format|
			if invite.update(p)
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

		invites_for_user = Invite.where(user_id: doorkeeper_token.resource_owner_id).where(accepted: nil).order('created_at DESC')

		render json: invites_for_user.map {|invite|
			{
				id: invite.id,
				title: invite.challenge.title,
				invited: invite.user.username,
				invited_id: invite.user.id,
				invited_by: User.find(invite.challenge.user_id).username,
				invited_by_profileimage: User.find(invite.challenge.user_id).profileimage.url(:thumb),
				invited_by_id: invite.challenge.user_id,
				accepted: invite.accepted
			}
		}
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
