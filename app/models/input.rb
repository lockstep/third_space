class Input < ApplicationRecord
  belongs_to :problem
  LENSES = %w(adaptability cultural_competence empathy intellectual_curiosity thinking)
  TYPES = %w(solution result summary)
end
