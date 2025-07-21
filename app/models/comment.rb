class Comment < ApplicationRecord
  PERMIT_PARAMS = %i(content article_id).freeze

  belongs_to :user
  belongs_to :article
end
