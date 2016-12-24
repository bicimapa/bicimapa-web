class Moderator::ZonesController < Moderator::ModeratorController
  before_action :set_zone, only: [:show]

  # GET /zones
  # GET /zones.json
  def index
    @zones = current_user.zones.page(params[:page])
  end

  # GET /zones/1
  # GET /zones/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_zone
    @zone = Zone.find(params[:id])
  end
end
