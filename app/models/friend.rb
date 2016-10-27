class Friend < ActiveRecord::Base
  belongs_to :friend_one, :class_name => 'User'
  belongs_to :friend_two, :class_name => 'User'
  belongs_to :user
  has_many :activities

  def friend_id(f1_id, f2_id, dk_id)

    @val1 = Integer(f1_id)
    @val2 = Integer(f2_id)
    @val3 = Integer(dk_id)

    if @val1 == @val3
      id = @val2
    elsif @val2 == @val3
      id = @val1
    else
      id = 3
    end

    return id
  end

end
