class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def after_sign_in_path_for(resource)
  #  request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  # end

  before_action :set_locale
  before_action :manage_flash

  private

  def manage_flash
    gon.flash = []
    flash.each do |key, msg|
      gon.flash << {
        message: msg,
        type: key
      }
    end
  end

  def set_locale
    user_locale = nil

    user_locale = current_user.locale if user_signed_in?

    I18n.locale = params[:locale] || user_locale || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end
end
