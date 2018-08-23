class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_filter :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".flash"
    redirect_to login_path
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
