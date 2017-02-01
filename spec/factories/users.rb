FactoryGirl.define do
  factory :user do
    email 'test@example.com'
    password 'password'
    role 'user'
  end
end
