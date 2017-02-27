class LandingController < ApplicationController

  skip_before_action :verify_authenticity_token

  def hello

  end

  def index
  end

  def create
    @presignup = Presignup.new(params[:presignup])
    if @presignup.save
      redirect_to root_path
    else
      render action: :new
    end
  end

  def new
    @presignup = Presignup.new
  end

end
