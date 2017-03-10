class SolutionLike < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  def toggle_liked
   self.update(liked: !self.liked)
  end

end
