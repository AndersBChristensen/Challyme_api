class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :complete
  belongs_to :challenge
  belongs_to :friend
  belongs_to :follower
  belongs_to :action

  def self.add_activity?(u_id, a_type, a_id)

    Activity.create({user_id: u_id, activity_type: a_type, activity_id: a_id})

  end

end
