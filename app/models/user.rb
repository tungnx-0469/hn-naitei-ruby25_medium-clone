class User < ApplicationRecord
  USER_UPDATE_PERMITTED_ATTRIBUTES = %i[username address phone_number date_of_birth bio avatar].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar

  validates :username, presence: true
  validates :phone_number, format: { with: Regexp.new(Settings.phone_number_regex), message: I18n.t("msg.invalid_phone_number") },
             allow_blank: true
  validates :avatar, content_type: { in: Settings.allowed_image_file_type,
                                    message: I18n.t("msg.invalid_image") },
                      size: { less_than: Settings.max_file_size.megabytes, message: I18n.t("msg.image_too_large") }
end
