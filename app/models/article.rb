class Article < ApplicationRecord
  PERMITTED_ATTIBUTES = %i[title content].freeze

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :liked_users, through: :favorites, source: :user
  has_rich_text :content

  validates :title, presence: true, length: { maximum: Settings.article_title_max_length }
  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def like_count
    liked_users.count
  end
end
