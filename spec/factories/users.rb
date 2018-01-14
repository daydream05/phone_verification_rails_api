FactoryBot.define do
  factory :user do
    sequence(:email){|n| "user#{n}@factory.com" }
    name "#{Faker::Name.first_name} #{Faker::Name.last_name}"
    password "12345678"
    password_confirmation "12345678"
  end
end
