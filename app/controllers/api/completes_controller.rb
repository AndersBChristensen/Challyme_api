class Api::CompletesController < ApplicationController
  before_action :doorkeeper_authorize!, except: [:create, :showAllActionForUser, :destroy] #Todo sæt tilbage til at have oauth
  before_action :set_complete, only: [:destroy]
  skip_before_action :verify_authenticity_token


  def index
    completes = Complete.all
    render json:completes
  end

  def destroy
    complete.destroy
    respond_to do |format|
      msg = { :status => "ok", :message => "success", :html => "<b>...</b>" }
      format.json  { render :json => msg }
    end
  end


  def showAllActionForUser
    #
    # Show all actions sorted by date, and if they are completed or not.
    #

    #completed = Complete.select('completes.action_dates_id')

    actions = Invite.select('actions.id as ActionId', 'actions.name as ActionName', 'task_dates.date as TaskDate', 'task_dates.id as ActionDate_id', 'invites.user_id as User', 'completed.task_dates_id as completed', 'invites.id')
                  .joins('inner join users on invites.user_id = users.id
inner join challenges on invites.challenge_id = challenges.id
inner join tasks on challenges.id = tasks.challenge_id
inner join actions on tasks.id = actions.task_id
inner join task_dates on actions.id = task_dates.action_id
left join completes as completed on task_dates.id = completed.task_dates_id
').where(user_id: params[:id]).where(:accepted =>  true).order('task.date ASC')

    #Show completed actions
    #.where('action_dates.id as complete' => Complete.select(:action_dates_id).map(&:action_dates_id))

    render json: actions

  end

  #
  # Complete a challenge. Checks if the id's exist in the tables.
  #
  def create

    if Complete.where(invite_id: params[:complete][:invite_id]).count > 0 && Complete.where(task_dates_id: params[:complete][:task_dates_id]).count > 0
      render json: {
          status: 400,
          message: "error"
      }.to_json
    else

      if  Invite.where(id: params[:complete][:invite_id]).count > 0 && TaskDate.where(id: params[:complete][:task_dates_id]).count > 0

        param = params.require(:complete).permit(:task_dates_id, :invite_id, :image, :video)
        complete = Complete.create(param)

        if complete
          render status: :created, json: complete
        else
          render :status => 400, json: $ERROR_INFO
        end

      else
        render json: {
            status: 400,
            message: "error"
        }.to_json
      end
    end
  end

  def challengeProcess
    #
    # Show process over how many actions there have been completed.
    #



  end

  private
  def set_complete
    complete = Complete.find(params[:id])
    render json: complete
  end

end
