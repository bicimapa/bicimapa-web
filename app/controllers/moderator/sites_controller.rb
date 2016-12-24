class Moderator::SitesController < Moderator::ModeratorController
  before_action :set_site, only: [:show, :edit, :update, :destroy, :rate, :activate, :deactivate]

  # GET /sites
  def index
    @sites = Kaminari.paginate_array(Site.find_by_sql(['select distinct s.* from sites s cross join (select polygon from moderators_zones mz join zones z on z.id = mz.zone_id where mz.moderator_id = ?) t where ST_Within(s.lonlat::geometry, t.polygon) = true and  s.deleted_at is null order by created_at desc', current_user.id])).page(params[:page]).per(20)
  end

  # GET /sites/review
  def review
    @sites = Kaminari.paginate_array(Site.find_by_sql(['select distinct s.* from sites s cross join (select polygon from moderators_zones mz join zones z on z.id = mz.zone_id where mz.moderator_id = ?) t where ST_Within(s.lonlat::geometry, t.polygon) = true and s.has_been_reviewed = false and s.deleted_at is null order by created_at desc', current_user.id])).page(params[:page]).per(20)
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
        format.html { redirect_to moderator_site_path(@site), notice: 'Site was successfully created.' }
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
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to moderator_site_path(@site), notice: 'Site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to moderator_sites_url }
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = Site.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    lonlat = factory.point(params[:site][:longitude], params[:site][:latitude])
    params.require(:site).permit(:name, :description, :is_active, :deleted_at, :category_id, :has_been_reviewed, :picture_1, :picture_2, :picture_3).merge(:lonlat => lonlat)
  end
end
