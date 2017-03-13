class CommentsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, raise: false
  before_action :get_comment, only: [ :edit, :update, :destroy ]

  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to problem_path(comment_params[:problem_id])
    else
      redirect_to :back
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
        redirect_to problem_path(@comment.problem.id)
    else
      redirect_back(fallback_location: problem_path(@comment.problem.id))
    end
  end

  def destroy
    if @comment.destroy
      redirect_to problem_path(@comment.problem.id)
    end
  end

  private

  def get_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:description, :problem_id, :user_id)
  end
end
