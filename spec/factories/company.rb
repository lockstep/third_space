FactoryGirl.define do
  factory :company do
    sequence(:name) { |n| "company#{n}" }
    sequence(:domain_name) { |n| "company#{n}.com" }
  end
end
