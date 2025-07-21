class NotificationsController < ApplicationController
  load_and_authorize_resource except: [:mark_read_all]
  def read
    @notification.update(read: true) unless @notification.read
    redirect_to direct_path
  end

  def mark_read_all
    authorize! :mark_read_all, Notification
    current_user.notifications.update_all(read: true)
    redirect_to request.referer || root_path
  end

  private
  def direct_path
    case @notification.notifiable
    when User
      profile_path(@notification.notifiable)
    when Article
      article_path(@notification.notifiable)
    when Comment
      article_path(@notification.notifiable.article)
    else
      root_path
    end
  end
end
