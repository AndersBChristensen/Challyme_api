class Api::LocationsController < ApplicationController

  before_action :doorkeeper_authorize!, except: []
  skip_before_action :verify_authenticity_token

  def create
    @p = params.permit(:latitude, :longitude, :altitude, :course, :completes_id)
    @location = Location.create(@p)

    if @location
      render :status => :created, :json => @location
    else
      render :status => 400, json: []
    end
  end

  def create_all_locations
    @locations = params[:locations]

    if @locations.count != 0
      params[:locations].each do |l|
        if Complete.where(id: l[:completes_id]).count > 0
          Location.create(latitude: l[:latitude], longitude: l[:longitude], altitude: l[:altitude], course: l[:course], completes_id: l[:completes_id])
        end
      end
      render :status => created, json: @locations
    else
      render :status => 500, json: []
    end
  end

  def destroy_all_locations
    if Complete.find(params[:id]).present?
      @locations = Location.where(completes_id: params[:id])

      if @locations.destroy_all
        render :status => 200, json: @locations
      else
        render :status => 400, json: []
      end
    else
      render :status => 500, json: []
    end
  end
end

