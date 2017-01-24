class Input < ApplicationRecord
  belongs_to :problem
  LENSES = %w(adaptability cultural competence empathy intellectual curiosity)
end
