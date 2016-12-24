class Admin::Reports::CategoriesController < Admin::AdminController
  before_action :set_reports_category, only: [:show, :edit, :update, :destroy]

  # GET /reports/categories
  # GET /reports/categories.json
  def index
    @reports_categories = Reports::Category.page(params[:page])
  end

  # GET /reports/categories/1
  # GET /reports/categories/1.json
  def show
  end

  # GET /reports/categories/new
  def new
    @reports_category = Reports::Category.new
  end

  # GET /reports/categories/1/edit
  def edit
  end

  # POST /reports/categories
  # POST /reports/categories.json
  def create
    @reports_category = Reports::Category.new(reports_category_params)

    respond_to do |format|
      if @reports_category.save
        format.html { redirect_to [:admin, @reports_category], notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @reports_category }
      else
        format.html { render :new }
        format.json { render json: @reports_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/categories/1
  # PATCH/PUT /reports/categories/1.json
  def update
    respond_to do |format|
      if @reports_category.update(reports_category_params)
        format.html { redirect_to [:admin, @reports_category], notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @reports_category }
      else
        format.html { render :edit }
        format.json { render json: @reports_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/categories/1
  # DELETE /reports/categories/1.json
  def destroy
    @reports_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_reports_categories_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reports_category
    @reports_category = Reports::Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reports_category_params
    params.require(:reports_category).permit(:name, :description)
  end
end
