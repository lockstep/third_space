FactoryGirl.define do
  factory :input do
    problem
    lens Input::LENSES.sample
    input_type Input::TYPES.sample
    input_text "My text"
  end
end
