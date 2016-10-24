class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :complete
  belongs_to :challenge
  belongs_to :friend
  belongs_to :follower
  belongs_to :action

  def create_activity?(u_id, a_type, a_id)


    @params = params.permit(user_id: u_id, activity_type: a_type, activity_id: a_id)

    @activity = Activity.create(@params)

    if @activity
      render status: :created, json: @activity
    else
      render :status => 400
    end

  end

end
