class DataHandlingController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
  end
end
