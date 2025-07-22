class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale
  def set_locale
  locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.available_locales.include?(locale) ?
      locale : I18n.default_locale
  end
  def default_url_options
    { locale: I18n.locale }
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: t("msg.permission_denied")
  end

   rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_path, alert: t("msg.record_not_found")
  end
end
