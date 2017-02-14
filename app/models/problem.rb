class Problem < ApplicationRecord
  LENSES = %w(adaptability cultural_competence empathy intellectual_curiosity thinking)
  TYPES = %w(solution summary)

  belongs_to :user
  has_many :comments

  def self.next_lens(current_lens)
    return LENSES.last if LENSES.last == current_lens
    LENSES[LENSES.index(current_lens) + 1]
  end

  def get_lense_value(lense_type)
    lense = inputs.find_by(lens: lense_type)
    lense ? lense.input_text : ''
  end
end
