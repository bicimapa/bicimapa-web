class RegistrationsController < Devise::RegistrationsController
  layout 'devise'

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  def build_resource(hash = nil)
    super(hash)
    resource.locale = http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
  end
end
