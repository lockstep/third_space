class Input < ApplicationRecord
  belongs_to :problem
  LENSES = %w(adaptability cultural_competence empathy intellectual_curiosity thinking)
  TYPES = %w(solution summary)

  def self.next_lens(current_lens)
    return LENSES.last if LENSES.last == current_lens
    LENSES[LENSES.index(current_lens) + 1]
  end
end
