class Admin::Reports::SubCategoriesController < Admin::AdminController
  before_action :set_reports_sub_category, only: [:show, :edit, :update, :destroy]

  # GET /reports/sub_categories
  # GET /reports/sub_categories.json
  def index
    @reports_sub_categories = Reports::SubCategory.page(params[:page])
  end

  # GET /reports/sub_categories/1
  # GET /reports/sub_categories/1.json
  def show
  end

  # GET /reports/sub_categories/new
  def new
    @reports_sub_category = Reports::SubCategory.new
  end

  # GET /reports/sub_categories/1/edit
  def edit
  end

  # POST /reports/sub_categories
  # POST /reports/sub_categories.json
  def create
    @reports_sub_category = Reports::SubCategory.new(reports_sub_category_params)

    respond_to do |format|
      if @reports_sub_category.save
        format.html { redirect_to [:admin, @reports_sub_category], notice: 'Sub category was successfully created.' }
        format.json { render :show, status: :created, location: @reports_sub_category }
      else
        format.html { render :new }
        format.json { render json: @reports_sub_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/sub_categories/1
  # PATCH/PUT /reports/sub_categories/1.json
  def update
    respond_to do |format|
      if @reports_sub_category.update(reports_sub_category_params)
        format.html { redirect_to [:admin, @reports_sub_category], notice: 'Sub category was successfully updated.' }
        format.json { render :show, status: :ok, location: @reports_sub_category }
      else
        format.html { render :edit }
        format.json { render json: @reports_sub_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/sub_categories/1
  # DELETE /reports/sub_categories/1.json
  def destroy
    @reports_sub_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_reports_sub_categories_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reports_sub_category
    @reports_sub_category = Reports::SubCategory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reports_sub_category_params
    params.require(:reports_sub_category).permit(:name, :description, :category_id)
  end
end
