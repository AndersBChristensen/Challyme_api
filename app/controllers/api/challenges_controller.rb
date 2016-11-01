class Api::ChallengesController < ApplicationController
  #before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]

  def index
    challenges = Challenge.all
    render json: challenges
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
      msg = {:status => "ok", :message => "success", :html => "<b>...</b>"}
      format.json { render :json => msg }
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
  #					dates: [ "2016-01-01", "2016-02-01" ]
  #         actions: [
  #           {
  #             title: "sdiljfoier"
  #             type: "sldkfjlier"
  #           }
  #         ]
  #       }
  #     ]
  #   },
  #   receiver_ids: [ 12093809123, 123102983, 123098123 ]
  # }
  #
  def create_with_receivers

    challenge_params = params.require(:challenge).permit(:title,
                                                         :prize,
                                                         :status,
                                                         :user_id,
                                                         tasks: [
                                                                :id,
                                                                :title,
                                                                actions: [
                                                                          :id,
                                                                          :name,
                                                                          actionmodule: [
                                                                                        :id,
                                                                                        :moduletype,
                                                                                        :time
                                                                           ]
                                                                 ],
                                                                  task_dates: [
                                                                              :id,
                                                                              :date]
                                                                  ])



    tasks = challenge_params.delete(:tasks).map do |task|
      task[:actions_attributes] = task.delete(:actions).map do |action|
        if action[:actionmodule].present?
          action[:actionmodule_attributes] = action.delete(:actionmodule)
        end
        action
      end
      task[:task_dates_attributes] = task.delete(:task_dates)
      task
    end
    challenge_params[:tasks_attributes] = tasks


    challenge_params.permit!

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
