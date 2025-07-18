class Comment < ApplicationRecord
  PERMMIT_PARAMS = %i[content article_id].freeze

  belongs_to :user
  belongs_to :article
end
