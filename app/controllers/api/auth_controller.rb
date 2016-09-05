class Api::AuthController < ApplicationController

  layout "login"

  def login
    #@user = User.new
    @user = AuthHelper::Session.new
  end

  def validate
    @user = AuthHelper::Session.new(params[:auth_helper_session])

    if @user.save
      redirect_to root_path
    else
      render :login
    end
  end

  def logout
    current_user_session.destroy
    redirect_to 'api/login'
  end

end
