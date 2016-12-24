class Admin::Reports::StatusesController < Admin::AdminController
  before_action :set_reports_status, only: [:show, :edit, :update, :destroy]

  # GET /reports/statuses
  # GET /reports/statuses.json
  def index
    @reports_statuses = Reports::Status.page(params[:page])
  end

  # GET /reports/statuses/1
  # GET /reports/statuses/1.json
  def show
  end

  # GET /reports/statuses/new
  def new
    @reports_status = Reports::Status.new
  end

  # GET /reports/statuses/1/edit
  def edit
  end

  # POST /reports/statuses
  # POST /reports/statuses.json
  def create
    @reports_status = Reports::Status.new(reports_status_params)

    respond_to do |format|
      if @reports_status.save
        format.html { redirect_to admin_reports_status_path(@reports_status), notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @reports_status }
      else
        format.html { render :new }
        format.json { render json: @reports_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/statuses/1
  # PATCH/PUT /reports/statuses/1.json
  def update
    respond_to do |format|
      if @reports_status.update(reports_status_params)
        format.html { redirect_to admin_reports_status_path(@reports_status), notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @reports_status }
      else
        format.html { render :edit }
        format.json { render json: @reports_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/statuses/1
  # DELETE /reports/statuses/1.json
  def destroy
    @reports_status.destroy
    respond_to do |format|
      format.html { redirect_to admin_reports_statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reports_status
      @reports_status = Reports::Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reports_status_params
      params.require(:reports_status).permit(:code, :label, :description, :fa_icon, :is_final_state)
    end
end
