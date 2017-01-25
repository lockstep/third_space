class ProblemsController < ApplicationController
  PAGES = Input::LENSES + %w('review review_photo tst_stream)

  def index
  end

  def show
    @problem = Problem.find(params[:id])
    if !params[:page].blank? && PAGES.include?(params[:page])
      @page = params[:page]
      render template: "problems/input"
    else
      redirect_to root_path
    end
  end

  def new
    #render template: "problems/new"
  end

  def create
    problem = Problem.create(problem_params)
    redirect_to view_problems_path(problem.id, 'adaptability')
  end

  private

  def problem_params
    params.require(:problem).permit(:name)
  end

end
