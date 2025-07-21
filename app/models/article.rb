class Article < ApplicationRecord
  PERMITTED_ATTIBUTES = %i(title content).freeze

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :liked_users, through: :favorites, source: :user
  has_rich_text :content

  validates :title, presence: true,
length: {maximum: Settings.article_title_max_length}
  validates :content, presence: true

  scope :recent, ->{order(created_at: :desc)}

  def like_count
    liked_users.count
  end

  ransacker :content_body do |_parent|
    Arel.sql(
      "(SELECT action_text_rich_texts.body
        FROM action_text_rich_texts
        WHERE action_text_rich_texts.record_type = 'Article'
          AND action_text_rich_texts.record_id = articles.id
          AND action_text_rich_texts.name = 'content'
        LIMIT 1)"
    )
  end

  def self.ransackable_attributes _auth_object = nil
    %w(title content_body created_at)
  end

  def self.ransackable_associations _auth_object = nil
    %w(user rich_text_content)
  end
end
