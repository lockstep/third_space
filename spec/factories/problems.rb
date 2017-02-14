FactoryGirl.define do
  factory :problem do
    sequence(:name) { |n| "My Problem #{n}" }
    adaptability 'solution for adaptability'
    cultural_competence 'solution for cultural_competence'
    empathy 'solution for empathy'
    intellectual_curiosity 'solution for intellectual_curiosity'
    thinking 'solution for thinking'
  end
end
