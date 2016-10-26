class Api::CompletesController < ApplicationController
  before_action :doorkeeper_authorize!, except: [ :destroy] #Todo sæt tilbage til at have oauth
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

    actions = Invite.select('challenges.title as challengetitle','actions.id as action_id', 'actions.name as actionname', 'task_dates.date as taskdate', 'task_dates.id as taskdate_id', 'invites.user_id as user', 'completed.task_date_id as completed', 'invites.id')
                  .joins('inner join users on invites.user_id = users.id
inner join challenges on invites.challenge_id = challenges.id
inner join tasks on challenges.id = tasks.challenge_id
inner join actions on tasks.id = actions.task_id
inner join task_dates on tasks.id = task_dates.task_id
left join completes as completed on task_dates.id = completed.task_date_id
').where(user_id: doorkeeper_token.resource_owner_id).where(:accepted =>  true).where('task_dates.date >= ?', Date.today).order('task_dates.date ASC')

    render json: actions

  end

  def create
    #
    # Complete a challenge. Checks if the id's exist in the tables.
    #

    @p = params.permit(:invite_id, :task_date_id, :image)

    if Complete.where(invite_id: @p[:invite_id]).count > 0 && Complete.where(task_date_id: @p[:task_date_id]).count > 0
      render json: {
          status: 400,
          message: "error"
      }.to_json
    else

      if  Invite.where(id: @p[:invite_id]).count > 0 && TaskDate.where(id: @p[:task_date_id]).count > 0

        complete = Complete.create(@p)

        if complete
          Activity.add_activity(doorkeeper_token.resource_owner_id, 'completed_task', complete.id)
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

  def challengeprocess
    #
    # Show process over how many actions there have been completed.
    #

    @invites = Invite.where(user_id: doorkeeper_token.resource_owner_id, accepted: true)
    p @invites

    render json: @invites.map {|invite|
      {
          actions_completed: invite.completes.count,
          total_actions: invite.challenge.totals,
          challenge_id: invite.challenge.id,
          challenge_title: invite.challenge.title,
          creator: User.find(invite.challenge.user_id).username,
          creator_id: invite.challenge.user_id
      }
    }

  end

  private
  def set_complete
    complete = Complete.find(params[:id])
    render json: complete
  end

end
