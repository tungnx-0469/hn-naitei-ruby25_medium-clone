class ApplicationController < ActionController::Base
  include Pagy::Backend
  allow_browser versions: :modern
  before_action :set_ransack_query
  before_action :set_locale
  before_action :load_notifications, if: :user_signed_in?

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_path, alert: t("msg.permission_denied")
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    redirect_to root_path, alert: t("msg.record_not_found")
  end

  private
  def set_ransack_query
    @q = Article.ransack(params[:q])
  end

  def load_notifications
    @notifications = current_user.notifications.includes(:notifiable).recent
  end
end
