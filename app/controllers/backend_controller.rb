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

  def numberOfUsers
    @users = User.count

  end

end
