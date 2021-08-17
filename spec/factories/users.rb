FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '123qwe123' }
    password_confirmation { '123qwe123' }
  end
end
