class Admin::Reports::ReportsController < Admin::AdminController
  before_action :set_reports_report, only: [:show, :edit, :update, :destroy]

  # GET /reports/reports
  # GET /reports/reports.json
  def index
    @reports_reports = Reports::Report.page(params[:page])
  end

  # GET /reports/reports/1
  # GET /reports/reports/1.json
  def show
  end

  # GET /reports/reports/new
  def new
    @reports_report = Reports::Report.new
  end

  # GET /reports/reports/1/edit
  def edit
  end

  # POST /reports/reports
  # POST /reports/reports.json
  def create

    ActiveRecord::Base.transaction do
      @report = Reports::Report.new(reports_report_params)

      @report.origin = 'WEB'
      @report.user = current_user

      @report.save

      initial_state = Reports::State.new

      initial_state.report = @report
      initial_state.comment = I18n.t(:report_created)
      initial_state.status = Reports::Status.find_by_code('NEW')

      initial_state.save
    end

    respond_to do |format|
        format.html { redirect_to [:admin, @reports_report] }
    end
  end

  def update_status

  
      new_state = Reports::State.new

      new_state.report_id = params[:id] 
      new_state.comment = params[:comment] 
      new_state.status = Reports::Status.find_by_code(params[:status_code])

      new_state.save

      redirect_to admin_reports_report_path(params[:id])
    
  end

  # PATCH/PUT /reports/reports/1
  # PATCH/PUT /reports/reports/1.json
  def update
    respond_to do |format|
      if @reports_report.update(reports_report_params)
        format.html { redirect_to [:admin, @reports_report], notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @reports_report }
      else
        format.html { render :edit }
        format.json { render json: @reports_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/reports/1
  # DELETE /reports/reports/1.json
  def destroy
    @reports_report.destroy
    respond_to do |format|
      format.html { redirect_to admin_reports_reports_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reports_report
    @reports_report = Reports::Report.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reports_report_params
    params.require(:reports_report).permit(:description, :latitude, :longitude, :category_id, :sub_category_id)
  end
end
