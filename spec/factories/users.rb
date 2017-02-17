FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    first_name 'donale'
    last_name 'trump'
    password 'password'
    role 'user'
  end
end
