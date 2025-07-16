class User < ApplicationRecord
  USER_UPDATE_PERMITTED_ATTRIBUTES = %i[username address phone_number date_of_birth bio avatar].freeze
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  has_many :active_relationships, class_name: Relationship.name, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name, foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :articles
  has_many :favorites, dependent: :destroy
  has_many :favorite_articles, through: :favorites, source: :article

  validates :username, presence: true
  validates :phone_number, format: { with: Regexp.new(Settings.phone_number_regex), message: I18n.t("msg.invalid_phone_number") },
             allow_blank: true
  validates :avatar, content_type: { in: Settings.allowed_image_file_type,
                                    message: I18n.t("msg.invalid_image") },
                      size: { less_than: Settings.max_file_size.megabytes, message: I18n.t("msg.image_too_large") }

  # scope lấy các user gợi ý cho người dùng, nếu có user thì sẽ loại trừ user đó hoặc người user đó follow khỏi danh sách gợi ý
  scope :recommend_users, ->(user = nil) {
    users = user.present? ? where.not(id: user.id) : all
    users.limit(Settings.recommend_users_limit)
  }

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete other_user
  end
  def following?(other_user)
    following.include? other_user
  end

  def like?(article)
    favorite_articles.include? article
  end

  def like(article)
    favorite_articles << article
  end

  def unlike(article)
    favorite_articles.delete article
  end
end
