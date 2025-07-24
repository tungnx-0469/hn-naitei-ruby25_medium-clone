namespace :notification do
  desc "TODO"
  task send_daily_noti: :environment do
    User.find_each do |user|
      following_ids = user.following_ids
      next if following_ids.empty?

      new_articles_count = Article.where(user_id: following_ids)
                                  .where("created_at >= ?", 1.day.ago)
                                  .count

      if new_articles_count.positive?
        message = I18n.t("notification.daily_noti.new_articles", count: new_articles_count)
      else
        message = I18n.t("notification.daily_noti.no_new_articles")
      end
      Notification.create!(
        user: user,
        message: message,
        notifiable: User.find_by(id: user.id)
      )
      puts "Daily notification sent to #{user.email} with message: '#{message}'"
    end
  end
end
