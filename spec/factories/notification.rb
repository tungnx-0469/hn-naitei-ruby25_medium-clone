FactoryBot.define do
  factory :notification do
    association :user
    message { Faker::Lorem.sentence } 
    association :notifiable, factory: :article
    read { false }
  end
end
