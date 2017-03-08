class SolutionLikesController < ApplicationController
  def create
    problem_id = params[:id]
    solution_like = SolutionLike.new(
      user_id: current_user.id, problem_id: problem_id
    )
    if solution_like.save
      Problem.increase_likes_count(problem_id)
      redirect_to problem_path(problem_id)
    end
  end
end
