class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :complete
  belongs_to :challenge
  belongs_to :friend
  belongs_to :follower
  belongs_to :action

  has_and_belongs_to_many :relevant_users, class_name: 'User'

  def task_name_for_activity(a_type, a_id)

    action_name = ''

    if Complete.exists?(a_id) && a_type == 'completed_task'

    @complete = Complete.find(a_id)

    @task_date = @complete.task_date

    @task = @task_date.task

    @actions = @task.actions



    @actions.find_each do |action|
      if action.task_id == @task_date.task_id
        action_name = action.name
      end
    end

    action_name

    else

      action_name

    end

  end

  def self.add_activity(u_id, a_type, a_id)

    activity = Activity.create({user_id: u_id, activity_type: a_type, activity_id: a_id})

    case activity.activity_type

      when 'started_following'

        @follower = Follower.find(activity.activity_id)
        activity.relevant_users << User.find(@follower.follower_two_id)

      when 'stopped_following'

        activity.relevant_users << User.find(activity.activity_id)

      when 'friend_request'

        @friend = Friend.find(activity.activity_id)
        activity.relevant_users << User.find(@friend.friend_two)

      when 'removed_friend_request'

        activity.relevant_users << User.find(activity.activity_id)

      when 'accepted_friend_request'

        @friend = Friend.find(activity.activity_id)
        activity.relevant_users << User.find(@friend.friend_one)

      when 'declined_friend'

        activity.relevant_users << User.find(activity.activity_id)

      when 'accepted_challenge'

        @invite_for_user = Invite.find(activity.activity_id)

        @challenge = Challenge.find(@invite_for_user.challenge_id)

        activity.relevant_users << User.find(@challenge.user_id)


      when 'declined_challenge'

        @invite_for_user = Invite.find(activity.activity_id)

        @challenge = Challenge.find(@invite_for_user.challenge_id)

        activity.relevant_users << User.find(@challenge.user_id)

      when 'completed_task'

        @complete = Complete.find(activity.activity_id)

        @invite_for_user = Invite.find(@complete.invite_id)

          @invites = Invite.where(challenge_id: @invite_for_user.challenge_id)

          @invites.each do |invite|
            if invite.user_id != activity.user_id
              activity.relevant_users << User.find(invite.user_id)
            end
          end


      else
        raise Exception.new('Ikkefsfrsf')
    end

  end

end
