class RidesController < ApplicationController
  before_action :set_ride, only: [:show, :edit, :update, :destroy]

  # GET /rides
  # GET /rides.json
  def index

    authorize Ride

    if Rails.env.production?
      ip = request.remote_ip
    else
      ip = '176.179.249.239'
    end
      
    response = HTTParty.get("http://ip-api.com/json/#{ip}")
    data = response.parsed_response

    @city = data["city"]
    @lon = data["lon"]
    @lat = data["lat"]

    @near_rides = Ride.where(["ST_Contains(ST_Buffer(ST_GeographyFromText('POINT(? ?)'), 25000)::geometry, rides.path)", @lon, @lat]).order(start: :desc).all
    @other_rides = Ride.where(["not ST_Contains(ST_Buffer(ST_GeographyFromText('POINT(? ?)'), 25000)::geometry, rides.path)", @lon, @lat]).order(start: :desc).all
  end

  # GET /rides/1
  # GET /rides/1.json
  def show
    authorize @ride
  end

  # GET /rides/new
  def new
    authorize Ride
    @ride = Ride.new
  end

  # GET /rides/1/edit
  def edit
    authorize @ride
  end

  # POST /rides
  # POST /rides.json
  def create

    authorize Ride

    @ride = Ride.new(ride_params)
    @ride.user = current_user

    respond_to do |format|
      if @ride.save
        format.html { redirect_to @ride, notice: 'Ride was successfully created.' }
        format.json { render :show, status: :created, location: @ride }
      else
        @ride.path = ride_params[:path]
        format.html { render :new }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rides/1
  # PATCH/PUT /rides/1.json
  def update
  
    authorize @ride

    respond_to do |format|
      if @ride.update(ride_params)
        format.html { redirect_to @ride, notice: 'Ride was successfully updated.' }
        format.json { render :show, status: :ok, location: @ride }
      else
        format.html { render :edit }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    authorize @ride
    @ride.destroy
    respond_to do |format|
      format.html { redirect_to rides_url, notice: 'Ride was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride
      @ride = Ride.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_params
      params.require(:ride).permit(:name, :description, :start, :end, :path, :user_id, :picture)
    end
end
