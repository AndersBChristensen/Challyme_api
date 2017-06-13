class SessionsController < ApplicationController

  skip_before_action :verify_authenticity_token


  def new
  end

  def create
    @user = User.find_by(email: params[:sessions_path][:email])
    if @user && @user.valid_password?(params[:sessions_path][:password])
      session[:user_id] = @user.id
      flash[:success] = "Velkommen tilbage!"
      redirect_to root_path
    else
      flash[:warning] = "Du har indtastet den forkerte email eller password."
      redirect_to :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
