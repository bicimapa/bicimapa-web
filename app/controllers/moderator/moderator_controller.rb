class Moderator::ModeratorController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_moderator

  layout 'moderatorlte'

  def check_if_moderator
    redirect_to :root, notice: 'You must be a moderator to continue' unless current_user.is_moderator?
  end
end
