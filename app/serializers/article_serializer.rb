class ArticleSerializer < ActiveModel::Serializer
  attributes %i(id title content user_id created_at updated_at)
end
