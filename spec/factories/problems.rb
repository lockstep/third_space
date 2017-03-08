FactoryGirl.define do
  factory :problem do
    sequence(:name) { |n| "My Problem #{n}" }
    adaptability 'solution for adaptability'
    cultural_competency 'solution for cultural_competency'
    empathy 'solution for empathy'
    intellectual_curiosity 'solution for intellectual_curiosity'
    thinking 'solution for thinking'
    public false
  end
end
