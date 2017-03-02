FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    first_name 'donale'
    last_name 'trump'
    password 'password'
    role 'user'

    trait :admin do
      role 'admin'
    end

    factory :user_with_company do
      company
    end
  end
end
