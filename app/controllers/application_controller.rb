class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_filter :set_locale
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def hello
    render html: "hello, world!"
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
