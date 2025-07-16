class Article < ApplicationRecord
  PERMITTED_ATTIBUTES = %i[title content].freeze

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :liked_users, through: :favorites, source: :user
  has_rich_text :content

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def like_count
    liked_users.count
  end
end
