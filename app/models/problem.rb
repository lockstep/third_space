class Problem < ApplicationRecord
  LENSES = %w(adaptability cultural_competence empathy intellectual_curiosity thinking)
  TYPES = %w(solution summary)

  belongs_to :user
  has_many :comments, dependent: :destroy

  scope :ordered_by_date, -> { order(created_at: :desc) }
  scope :in_company, -> (user) {
    return where(user: user) if user.company.nil?
    user_ids = User.where(company_id: user.company_id).pluck(:id)
    where(user_id: user_ids)
  }
  scope :be_published, -> { where(public: true) }
  scope :view_all, -> (user) { be_published.or(in_company(user)) }

  def self.next_lens(current_lens)
    return LENSES.last if LENSES.last == current_lens
    LENSES[LENSES.index(current_lens) + 1]
  end

  def get_lense_value(lense_type)
    lense = inputs.find_by(lens: lense_type)
    lense ? lense.input_text : ''
  end
end
