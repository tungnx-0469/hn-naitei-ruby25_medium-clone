class UserNotiJob
  include Sidekiq::Job

  def perform user_id, message, notifiable_type, notifiable_id
    user = User.find_by(id: user_id)
    return unless user

    Notification.create!(
      user: user,
      message: message,
      notifiable_type: notifiable_type,
      notifiable_id: notifiable_id,
      read: false
    )
  end
end
