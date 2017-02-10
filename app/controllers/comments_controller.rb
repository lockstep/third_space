class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to discuss_problems_path(comment_params[:problem_id])
    else
      redirect_to :back
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:description, :problem_id, :user_id)
  end
end
