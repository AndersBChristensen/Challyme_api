class BackendController < ApplicationController
  skip_before_action :verify_authenticity_token


  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  def deleteSession
    session.delete(:user_id)
    redirect_to root_path
  end

  def numberOfUsers
    @users = User.count
  end

end
