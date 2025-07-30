FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    association :user
  end
end
