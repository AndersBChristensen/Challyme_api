class Api::ChallengesController < ApplicationController
	#before_action :doorkeeper_authorize!
	skip_before_action :verify_authenticity_token
	before_action :set_challenge, only: [:show, :edit, :update, :destroy]

	def index
		challenges = Challenge.all
		render json:challenges
	end

	def show
	end

	def create

		# Todo - Create challenge

		challenge = Challenge.create(challenge_params)

		

		if challenge
			render :status => :created, :json => challenge
		else
			render :status => 400 
		end
	end

	def update

		respond_to do |format|
			if challenge.update(challenge_params)
				render :status => :updated, :json => challenge
			else
				render :status => 400
			end
		end
	end

	def destroy
		challenge.destroy
		respond_to do |format|
			msg = { :status => "ok", :message => "success", :html => "<b>...</b>" }
    		format.json  { render :json => msg }
    	end
	end

	# Forventet json:
	# {
	#   challenge: {
	#  	  title: "Månedens program",
	#     prize: "En tur i biografen"	
	#     tasks: [
	#       {
	#         title: "sdflkjelr"
	#         actions: [
	#           {
	#             title: "sdiljfoier"
	#             type: "sldkfjlier"
	#             dates: [ "2016-01-01", "2016-02-01" ]
    #           }
    #         ]
    #       }
	#     ]
	#   },
	#   receiver_ids: [ 12093809123, 123102983, 123098123 ]
	# }
	#
	def create_with_receivers

		challenge_params = params.require(:challenge).permit(:title, :prize, :status, :user_id, tasks_attributes: [:id, :title,
																																														actions_attributes: [:id, :name, actionmodules_attributes:[:id, :text, :countertype, :countertime]],
																																																							 action_dates_attributes: [:id, :date]])

		receiver_ids = params.require(:receiver_ids)

		challenge = Challenge.create(challenge_params)

		unless challenge
			render status: :bad_request
			return
		end

		receiver_ids.each do |user_id|
			if challenge.user_id == user_id
        Invite.create(challenge_id: challenge.id, user_id: user_id, accepted: true)
      else
        Invite.create(challenge_id: challenge.id, user_id: user_id)
      end
		end


		render status: :created, json: challenge
	end

	private
		def set_challenge
			challenge = Challenge.find(params[:id])
			render json: challenge
		end
		def challenge_params
      		params.require(:challenge).permit(:title, :prize)
    	end

 
end
