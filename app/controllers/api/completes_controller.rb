class Api::CompletesController < ApplicationController
  before_action :doorkeeper_authorize!, except: [ :destroy, :home_feed, :showAllActionForUser] #Todo sæt tilbage til at have oauth
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
    #.where('task_dates.date >= ?', Date.today).where('invite.user_id = ?', 3) .where('invite.accepted = ?', true)

    #invite = Invite.all_actions_for_user(3)

    #render json: {
     #     invites: invite
    #}

    invites = Invite.where(user_id: 3, accepted: true)

    tasks = invites.reduce([]) do |acc, invite|
      tasks = invite.challenge.tasks

      tasks.each do |task|

        logger.info "In task"
        task_dates = task.task_dates.where('date >= ?', Date.today)
        task_actions = task.actions
        task_dates.each do |task_date|
          task_actions.each do |action|
            acc.push({
                taskname: task.title,
                task_id: task.id,

                action_id: action.id,
                actionname: action.name,

                taskdate_id: task_date.id,
                taskdate: task_date.date,

                moduletype: action.actionmodule.try(:type),
                moduletime: action.actionmodule.try(:time),

                user_id: invite.user_id,

                complete_status: action.complete_status(invite.id, task_date.id),

                challengetitle: invite.challenge.title,
                invite_id: invite.id,

             })

          end
        end


      end
      acc
    end

    render json: tasks

  end

  def showAllActionsForInvite

    actions = Invite.select('challenges.title as challengetitle','actions.id as action_id', 'actions.name as actionname', 'task_dates.date as taskdate', 'task_dates.id as taskdate_id', 'invites.user_id as user', 'completed.task_date_id as completed', 'invites.id')
                  .joins('inner join users on invites.user_id = users.id
inner join challenges on invites.challenge_id = challenges.id
inner join tasks on challenges.id = tasks.challenge_id
inner join actions on tasks.id = actions.task_id
inner join task_dates on tasks.id = task_dates.task_id
left join completes as completed on task_dates.id = completed.task_date_id
').where(user_id: doorkeeper_token.resource_owner_id).where(id: params[:id]).where('task_dates.date >= ?', Date.today).order('task_dates.date ASC')

    render json: actions
  end

  def create
    #
    # Complete a challenge. Checks if the id's exist in the tables.
    #

    @p = params.permit(:invite_id, :task_date_id, :image, :description)

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
          creator_image: User.find(invite.challenge.user_id).profileimage,
          creator_id: invite.challenge.user_id
      }
    }

  end

  def upload_complete_image
    @p = params.permit(:image_data, :id, :task_date_id, :invite_id)
    if Complete.exists?(id: @p[:id])

      @complete = Complete.find(@p[:id])

      image_data = @p[:image_data]

      respond_to do |format|
        if @complete.update_attributes(image: image_data)
          format.json { render :status => :ok, json: :updated }
        else
          format.json { render :status => 400 }
        end
      end
    end
  end

  def home_feed

    @p = params.permit(:user_id, :challenge_status)

    @completes = Complete.select('completes.created_at as complete_date', 'completes.description', 'completes.image', 'tasks.title AS task_title', 'actions.name', 'users.username as username', 'users.first_name as firstname', 'users.last_name as lastname', 'challenges.title AS challenge_title').joins('LEFT JOIN invites ON completes.invite_id = invites.id
                                  LEFT JOIN challenges ON invites.challenge_id = challenges.id
                                  LEFT JOIN users ON invites.user_id = users.id
                                  LEFT JOIN task_dates ON completes.task_date_id = task_dates.id
                                  LEFT JOIN tasks on task_dates.task_id = tasks.id
                                  LEFT JOIN actions on tasks.id = actions.task_id').where('invites.user_id = :val1 AND challenges.status = :val2', val1: @p[:user_id], val2: @p[:challenge_status])

    render json: @completes

  end

  private
  def set_complete
    complete = Complete.find(params[:id])
    render json: complete
  end

end
