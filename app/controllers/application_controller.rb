class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :store_current_location, unless: :devise_controller?

  before_action :authenticate_user!, :set_locale

  include Pundit
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def store_current_location
    store_location_for(:user, request.url) unless request.xhr?
  end

  def user_not_authorized
    flash[:alert] = t('pundit.user_not_authorized')
    redirect_to(root_path)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
