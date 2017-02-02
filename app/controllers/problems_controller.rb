class ProblemsController < ApplicationController
  PAGES = %w(next edit)

  def index
    @problems = params[:stream].blank? ? current_user.problems : Problem.all
    render template: "problems/tst_stream"
  end

  def show
    return redirect_to root_path if params[:lens].blank?
    @problem = Problem.find(params[:id])
    @page = params[:lens]
    if Input::LENSES.include?(params[:lens])
      render template: "problems/input"
    elsif PAGES.include?(params[:lens])
      render template: "problems/#{params[:lens]}"
    else
      redirect_to root_path
    end
  end

  def new
    problem = Problem.new
    problem.user = current_user
    problem.save
    redirect_to edit_problem_path(problem.id)
  end

  def update
    @problem = Problem.find(problem_params[:id])
    @problem.update(problem_params)
    return render status: 200, json: '' if problem_params[:image].blank?
    redirect_to edit_problem_path(@problem.id)
  end

  private

  def problem_params
    params.require(:problem).permit(:id, :name, :image)
  end

end
