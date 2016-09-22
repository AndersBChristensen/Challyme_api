class HomeController < ApplicationController

  def new
    @presignup = Presignup.new
  end

  def create
    @presignup = Presignup.new(set_params)

    if @presignup.save
      redirect_to '/', notice: 'Du er nu blevet skrevet op, vi glæder os til at se dig!'
    else
      render :new
    end
  end

  private def set_params
    params.require(:presignup).permit(
        :email)
  end

end
