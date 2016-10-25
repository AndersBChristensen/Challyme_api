class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_attached_file :profileimage, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profileimage, content_type: /\Aimage\/.*\z/

  has_attached_file :coverimage, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :coverimage, content_type: /\Aimage\/.*\z/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :invites
	has_many :challenges
	has_many :friends
  has_many :followers
  has_many :activities
  has_and_belongs_to_many :activities
	accepts_nested_attributes_for :challenges
	accepts_nested_attributes_for :invites
	accepts_nested_attributes_for :friends
  accepts_nested_attributes_for :followers


	def friend_status?(myId, userId)
			if Friend.where(friend_one_id: myId, friend_two_id: userId, status: 1).count > 0
				status = true
			elsif Friend.where(friend_two_id: myId, friend_one_id: userId, status: 1).count > 0
				status = true
    	else
				status = false
			end
			status
	end

  def follower_status?(myId, userId)
    if Follower.where(follower_one_id: myId, follower_two_id: userId).count > 0
      status = true
    else
      status = false
    end
    status
  end

  def who_follow_me(myId)
    total_followers = Follower.where(follower_two_id: myId).count
    total_followers
  end

  def total_friends(myId)
    friend1 = Friend.where(friend_one_id: myId,  status: 1).count
    friend2 = Friend.where(friend_two_id: myId, status: 1).count
    friend1 + friend2
  end

  def who_i_follow(myId)
    total_followers = Follower.where(follower_one_id: myId).count
    total_followers
  end

  def pending_friend_status?(myId, userId)
    if Friend.where(friend_one_id: myId, friend_two_id: userId, status: 0).count > 0
      status = true
    elsif Friend.where(friend_two_id: myId, friend_one_id: userId, status: 0).count > 0
      status = true
    else
      status = false
    end
    status
  end

  def username?(id)
    user = User.find(id)
    user.username
  end

  def firstname?(id)
    user = User.find(id)
    user.first_name
  end

  def lastname?(id)
    user = User.find(id)
    user.last_name
  end

  def user_id?(id)
    user = User.find(id)
    user.id
  end

  def upload_profile_image
    @p = params.permit(:profileimage, :user_id)

    if User.exists?(id: @p[:user_id])

      @profile_image = User.new(@p)
      #@room_photo.update_attributes(room_id: :id)

      if @profile_image.save
        render :status => :created, :json => @profile_image
      else
        render :status => 400, json: []
      end
    end
  end

  def upload_cover_image
    @p = params.permit(:coverimage, :user_id)

    if User.exists?(id: @p[:user_id])

      @profile_image = User.new(@p)
      #@room_photo.update_attributes(room_id: :id)
      
      if @profile_image.save
        render :status => :created, :json => @profile_image
      else
        render :status => 400, json: []
      end
    end
  end

end
