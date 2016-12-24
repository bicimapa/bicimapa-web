class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include Devise::Controllers::Rememberable

  def facebook
    
    auth = request.env['omniauth.auth']

    app = FbGraph::Application.new(ENV['FACEBOOK_APP_ID'], secret: ENV['FACEBOOK_SECRET_ID'])
    facebook_user = FbGraph::User.fetch(auth.uid, access_token: app.get_access_token)

    unless facebook_user.permissions.include? :email
      return redirect_to new_user_registration_url, flash: { alert: I18n.t(:facebook_email_alert)}
    end

    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(auth)
    remember_me(@user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      session['devise.facebook_data'] = auth
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = auth
      redirect_to new_user_registration_url
    end
  end
end
