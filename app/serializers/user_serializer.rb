class UserSerializer < ActiveModel::Serializer
  attributes %i(id username email bio address phone_number created_at
updated_at)
end
