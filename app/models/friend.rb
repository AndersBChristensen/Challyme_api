class Friend < ActiveRecord::Base
  belongs_to :friend_one, :class_name => 'User'
  belongs_to :friend_two, :class_name => 'User'
  belongs_to :user
  has_many :activities

  def friend_id(f1_id, f2_id, dk_id)

    logger.info(f1_id)
    logger.info(f2_id)
    logger.info(dk_id)

    if f1_id == dk_id
      logger.info('inside if')
      id = f2_id
      id
    elsif f2_id == dk_id
      logger.info('elseif')
      id = f1_id
      id
    else
      logger.info('else')
      id = 3
      id
    end

  end

end
