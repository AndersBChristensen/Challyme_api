class LandingPageController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :set_signup, only: [:edit, :update, :destroy]

  def index

  end

  def show
  end

  def new
  end

  def create

  end

  def add_signup

  end

  private def set_params

  end

  def set_signup
  end

end
