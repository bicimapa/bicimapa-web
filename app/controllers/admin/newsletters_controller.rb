class Admin::NewslettersController < Admin::AdminController
  before_action :set_newsletter, only: [:show, :edit, :destroy, :update]

  def index
    @newsletters = Newsletter.order(:created_at => :desc).page params[:page]
  end

  def show
  end

  def edit
  end

  def extract_users
    @users = User.select(:email, :last_name, :first_name).all
    headers['Content-Disposition'] = "attachment; filename=\"user-list.csv\""
    headers['Content-Type'] ||= 'text/csv'
    render layout: false
  end

  def extract_newsletters
    @newsletters = Newsletter.select(:email, :last_name, :first_name).all
    headers['Content-Disposition'] = "attachment; filename=\"newsletter-list.csv\""
    headers['Content-Type'] ||= 'text/csv'
    render layout: false
  end

  def extract_users_and_newsletters
    @users = User.select(:email, :last_name, :first_name).all
    @newsletters = Newsletter.where('newsletters.email not in (select users.email from users)').select(:email, :last_name, :first_name).all
    headers['Content-Disposition'] = "attachment; filename=\"user-newsletter-list.csv\""
    headers['Content-Type'] ||= 'text/csv'
    render layout: false
  end

  def destroy
    @newsletter.destroy
    respond_to do |format|
      format.html { redirect_to admin_newsletters_url }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @newsletter.update(newsletter_params)
        format.html { redirect_to admin_newsletter_path(@newsletter), notice: 'Newsletter was successfully updated.' }
        format.json { render :show, status: :ok, location: @newsletter }
      else
        format.html { render :edit }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  #
  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def newsletter_params
    params.require(:newsletter).permit(:email, :last_name, :first_name)
  end
end
