class Friend < ActiveRecord::Base
  belongs_to :friend_one, :class_name => 'User'
  belongs_to :friend_two, :class_name => 'User'
  belongs_to :user
  has_many :activities

  def friend_id(f1_id, f2_id, dk_id)

    id = 0

    if f1_id == dk_id
      id = f2_id

    elsif f2_id == dk_id
      id = f1_id
    end

    id

  end

end
