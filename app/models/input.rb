class Input < ApplicationRecord
  belongs_to :problem
  LENSES = %w(adaptability cultural_competence empathy intellectual_curiosity thinking)
  TYPES = %w(solution result summary)
  validates_inclusion_of :lens, in: LENSES
  validates_inclusion_of :input_type, in: TYPES
end
