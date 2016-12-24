class ReportsController < ApplicationController

  before_action :set_report, only: [:show]

  def index
    @reports = Reports::Report.all
  end

  def show
  end

  def new
    @report = Reports::Report.new

    if params[:pos]
      @latlng = params[:pos].split(',')

      @report.latitude = @latlng[0]
      @report.longitude = @latlng[1]
    end
  end

  def create

    ActiveRecord::Base.transaction do
      @report = Reports::Report.new(report_params)

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
        format.html { redirect_to report_path(@report) }
    end
  end

  private

  def set_report
    @report = Reports::Report.find(params[:id])
  end

  def report_params
    params.require(:reports_report).permit(:description, :latitude, :longitude, :category_id, :sub_category_id, :photo)
  end

end
