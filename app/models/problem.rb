class Problem < ApplicationRecord
  LENSES = %w(adaptability cultural_competency empathy intellectual_curiosity thinking)
  TYPES = %w(solution summary)

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :solution_likes

  scope :ordered_by_date, -> { order(created_at: :desc) }
  scope :be_completed, -> { where.not('thinking' => nil) }
  scope :in_company, -> (user) {
    return where(user: user) if user.company.nil?
    user_ids = User.where(company_id: user.company_id).pluck(:id)
    where(user_id: user_ids)
  }
  scope :published, -> { where(public: true) }
  scope :view_all, -> (user) {
    (published.be_completed).or(in_company(user).be_completed)
  }

  def self.next_lens(current_lens)
    return LENSES.last if LENSES.last == current_lens
    LENSES[LENSES.index(current_lens) + 1]
  end

  def self.toggle_likes_count(problem_id, liked)
    problem = Problem.find(problem_id)
    like_count = liked ? problem.likes_count + 1 : problem.likes_count - 1
    problem.update(likes_count: like_count)
  end

  def get_lens_value(lens_type)
    lens = inputs.find_by(lens: lens_type)
    lens ? lens.input_text : ''
  end

  def completed_problem?
    thinking.present?
  end

  def allow_visitor_to_see?(visitor)
    return true if public
    return false unless visitor
    user.domain_name ==  visitor.domain_name
  end
end
