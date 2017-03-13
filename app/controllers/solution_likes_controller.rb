class SolutionLikesController < ApplicationController
  before_action :authenticate_user!

  def toggle_like
    problem_id = params[:id]
    solution_like = SolutionLike.find_or_initialize_by(user_id: current_user.id, problem_id: problem_id)
    if solution_like.new_record?
      solution_like = SolutionLike.create(user_id: current_user.id, problem_id: problem_id)
    else
      solution_like.toggle_liked
    end

    Problem.toggle_likes_count(problem_id, solution_like.liked)
    head :ok
    # redirect_to problem_path(problem_id)
  end
end
