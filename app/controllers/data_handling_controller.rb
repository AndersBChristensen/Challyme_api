class DataHandlingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to data_handling_path, error: "Brugeren blev slettet"
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to '/data_handling'#, notice: "Brugeren blev opdateret"
    else
      render :edit
    end
  end

  def edit
      @user = User.find(params[:id])
      if @user.birthday.nil?
        @user.birthday = DateTime.now
      end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :username, :first_name, :last_name, :isAdmin, :city)
  end

end
