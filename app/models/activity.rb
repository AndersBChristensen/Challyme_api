class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :complete
  belongs_to :challenge
  belongs_to :friend
  belongs_to :follower
  belongs_to :action

  has_and_belongs_to_many :relevant_users, class_name: 'User'

  def self.add_activity(u_id, a_type, a_id)

    activity = Activity.create({user_id: u_id, activity_type: a_type, activity_id: a_id})

    case activity.activity_type

      when 'started_following'

        @follower = Follower.find(activity.activity_id)
        activity.relevant_users << User.find(@follower.follower_two_id)

      when 'stopped_following'

        @follower = Follower.find(activity.id)
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

    end

  end

end
