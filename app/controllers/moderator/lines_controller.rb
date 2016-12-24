class Moderator::LinesController < Moderator::ModeratorController
  before_action :set_line, only: [:show, :edit, :update, :destroy]

  # GET /lines
  # GET /lines.json
  def index
    query_lines = %{
      select l.* from zones z
      join moderators_zones mz on z.id = mz.zone_id
      join lines l on ST_Intersects(z.polygon, l.path)
      where moderator_id = #{current_user.id}
    }

    @lines = Line.find_by_sql(query_lines)
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
  end

  # GET /lines/new
  def new
    @line = Line.new
  end

  # GET /lines/1/edit
  def edit
  end

  # POST /lines
  # POST /lines.json
  def create
    @line = Line.new(line_params)

    @line.origin = 'WEB'

    @line.user = current_user

    respond_to do |format|
      if @line.save
        format.html { redirect_to moderator_line_path(@line), notice: 'Line was successfully created.' }
        format.json { render :show, status: :created, location: @line }
      else
        format.html { render :new }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lines/1
  # PATCH/PUT /lines/1.json
  def update
    respond_to do |format|
      if @line.update(line_params)
        format.html { redirect_to moderator_line_path(@line), notice: 'Line was successfully updated.' }
        format.json { render :show, status: :ok, location: @line }
      else
        format.html { render :edit }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.json
  def destroy
    @line.destroy
    respond_to do |format|
      format.html { redirect_to moderator_lines_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_line
    @line = Line.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def line_params
    params.require(:line).permit(:name, :description, :path, :is_active, :category_id)
  end
end
