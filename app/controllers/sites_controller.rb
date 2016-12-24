class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy, :rate, :comment]

  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.all
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

    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    @site.lonlat = factory.point(@latlng[1], @latlng[0])
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
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
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
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
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
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  # PATCH /sites/1/rate
  def rate
    rating = Rating.where(site_id: @site.id, user_id: current_user.id).first_or_create(site_id: @site.id, user_id: current_user.id)

    rating.rate = params[:rate]

    flash[:notice] = I18n.t(:rate_cant_be_empty) unless rating.save

    redirect_to site_path(@site)
  end

  # PATH /sites/1/comment
  def comment

    comment = @site.comments.create
    comment.comment = params[:comment]
    comment.user = current_user
    
    flash[:notice] = I18n.t(:comment_cant_be_empty) unless comment.save

    @site.comments.map { |c| c.user }.compact.uniq.reject { |u| u == current_user || u == @site.user }.each do |user|
      DefaultMailer.notify_site_new_comment(user, @site).deliver if user.receive_notifications
    end

    redirect_to site_path(@site)
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
    params.require(:site).permit(:name, :description, :is_active, :deleted_at, :category_id, :has_been_reviewed, :picture_1).merge(:lonlat => lonlat)
  end
end
