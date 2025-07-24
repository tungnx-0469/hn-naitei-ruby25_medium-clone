class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, ->{where(read: false)}
  scope :recent, ->{order(created_at: :desc)}
end
