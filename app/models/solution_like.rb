class SolutionLike < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  def self.can_create?(user_id, problem_id)
    !SolutionLike.where(user_id: user_id, problem_id: problem_id).any?
  end
end
