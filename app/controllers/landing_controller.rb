class LandingController < ApplicationController

  #skip_before_action :verify_authenticity_token
  skip_before_action :verify_authenticity_token
  before_action :set_signup, only: [:edit, :update, :destroy]

  def hello

  end

  def index
  end

  def show
    @pre = Presignup.find(params[:id])
  end

  def new
    @pre = Presignup.new
  end

  def create
    @pre = Presignup.new(set_params)

    if @pre.save
      redirect_to '/', notice: 'Du er nu blevet skrevet op, vi glæder os til at se dig!'
    else
      render :new
    end
  end

  def add_signup

    @pre = Presignup.new(email: @email)

    if @pre.save
      redirect_to '/', notice: 'Du er nu blevet skrevet op, vi glæder os til at se dig!'
    else
      render :new
    end

  end

  private def set_params
    params.require(:presignup).permit(
        :email)
  end

  def set_signup
    @pre = Presignup.find(params[:id])
  end

end
