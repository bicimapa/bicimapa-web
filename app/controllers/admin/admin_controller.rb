class Admin::AdminController < ApplicationController
  layout 'adminlte'

  before_action :authenticate_user!
  before_action :check_if_admin

  def check_if_admin
    redirect_to :root, notice: 'You must be admin to continue' unless current_user.is_admin?
  end
end
