class SessionsController < ApplicationController

  skip_before_action :verify_authenticity_token


  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Velkommen tilbage!"
      redirect_to root_path
    else
      flash[:warning] = "Du har indtastet den forkerte email eller password."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
