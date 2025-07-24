class Comment < ApplicationRecord
  PERMIT_PARAMS = %i[content article_id parent_id].freeze

  belongs_to :user
  belongs_to :article, counter_cache: true
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }

  def limit_depth_to_two_levels
    if parent.present? && parent.parent.present?
      errors.add(:base, 'Comments can only be nested one level deep.')
    end
  end
end
