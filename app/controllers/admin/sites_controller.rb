class Admin::SitesController < Admin::AdminController
  before_action :set_site, only: [:show, :edit, :update, :destroy, :rate, :activate, :deactivate, :remove_custom_icon]

  # GET /sites/review
  def review
    @sites = Site.order(created_at: :desc).where(has_been_reviewed: false).page params[:page]
  end

  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.order(created_at: :desc).page params[:page]
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
  end

  # GET /sites/new
  def new
    @site = Site.new

    return unless params[:pos]

    @latlng = params[:pos].split(',')

    @site.latitude = @latlng[0]
    @site.longitude = @latlng[1]
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)

    @site.origin = 'WEB'
    @site.user = current_user

    respond_to do |format|
      if @site.save
        format.html { redirect_to admin_site_path(@site), notice: 'Site was successfully created.' }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    
    @site.update(site_params)

    redirect_to admin_site_path(@site), notice: 'Site was successfully updated.'
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to admin_sites_url }
      format.json { head :no_content }
    end
  end

  # PATCH /sites/1/rate
  def rate
    rating = Rating.where(site_id: @site.id, user_id: current_user.id).first_or_create(site_id: @site.id, user_id: current_user.id)

    rating.rate = params[:rate]

    rating.save

    redirect_to site_path(@site)
  end

  # GET /sites/1/activate
  def activate
    @site.has_been_reviewed = true
    @site.is_active = true

    @site.save

    redirect_to :back
  end

  # GET /sites/1/activate
  def deactivate
    @site.has_been_reviewed = true
    @site.is_active = false

    @site.save

    redirect_to :back
  end

  # GET /sites/1/remove_custom_icon
  def remove_custom_icon
    @site.custom_icon = nil
    @site.save

    redirect_to :back
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = Site.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    lonlat = factory.point(params[:site][:longitude], params[:site][:latitude])
    params.require(:site).permit(:name, :description, :is_active, :deleted_at, :category_id, :has_been_reviewed, :picture_1, :picture_2, :picture_3, :custom_icon).merge(:lonlat => lonlat)
  end
end
