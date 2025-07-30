FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    user { association(:user) }
    article { association(:article) }
  end
end
