class ProfilesController < ApplicationController

  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def show
    @user = current_user
  end

  def update
    @user = current_user

    @user.update(params.require(:user).permit(:last_name, :first_name, :email, :locale, :avatar, :receive_notifications))

    redirect_to '/profile'
  end

  def unlink_facebook_profile
    @user = User.find_by_token(params[:token])
    @user.facebook_uid = nil
    @user.save
    redirect_to '/profile'
  end

  def link_to_facebook_profile
    @user = User.find_by_token(params[:token])
    @user.facebook_uid = params[:facebook_id]
    @user.save
    render nothing: true
  end

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end
end
