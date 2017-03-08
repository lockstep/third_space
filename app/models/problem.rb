class Problem < ApplicationRecord
  LENSES = %w(adaptability cultural_competency empathy intellectual_curiosity thinking)
  TYPES = %w(solution summary)

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :solution_likes

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

  def self.increase_likes_count(problem_id)
    problem = Problem.find(problem_id)
    problem.update(likes_count: problem.likes_count + 1)
  end

  def get_lens_value(lens_type)
    lens = inputs.find_by(lens: lens_type)
    lens ? lens.input_text : ''
  end
end
