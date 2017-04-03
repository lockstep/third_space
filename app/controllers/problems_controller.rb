class ProblemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_problem, only: [
    :edit, :update, :destroy, :show, :lens, :update_lens, :review,
    :share_by_email
  ]
  before_action :check_user_access, only: [:edit, :lens, :review]
  before_action :set_redirect_path, only: [:update]

  TEXTURE_IMAGE_AMOUNT = 10

  def index
    if params[:stream].blank?
      problems = current_user.problems.ordered_by_date
    else
      problems = Problem.view_all(current_user).ordered_by_date
    end
    @problems = problems.paginate(:page => params[:page], :per_page => 30)
  end

  def new
    visit_ace_it_form and return if has_unfinish_problem?
    @problem = Problem.new
    load_tips('problem')
  end

  def create
    @problem = Problem.new(problem_params.merge(user_id: current_user.id))
    if @problem.save(problem_params)
      redirect_to lenses_problem_path(id: @problem.id, lens: 'adaptability')
    else
      load_tips('problem')
      render :new
    end
  end

  def edit
    load_tips("problem")
  end

  def update
    if @problem.update(problem_params)
      redirect_to @redirect_path
    else
      redirect_back(fallback_location: problems_path)
    end
  end

  def show
    redirect_to root_path unless @problem.allow_visitor_to_see?(current_user)
    lens_index = params[:id].to_i % Problem::LENSES.length
    @lens = Problem::LENSES[lens_index]
    @image_index = (params[:id].to_i  % TEXTURE_IMAGE_AMOUNT) + 1
  end

  def destroy
    if @problem.destroy
      redirect_to problems_path
    end
  end

  def lens
    @lens = params[:lens]
    load_tips(@lens)
  end

  def update_lens
    if @problem.update(problem_params)
      if done_lens_form?(params[:problem][:lens])
        finish_lens_form
      else
        visit_next_lens_form(params[:problem][:lens])
      end
    else
      redirect_back(fallback_location: problems_path)
    end
  end

  def review
  end

  def share_by_email
    UserMailer.problem_with_solution(
      @problem.id, params[:problem][:email]
    ).deliver
    head :ok
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def load_tips(lens)
    all_tips = YAML.load_file(File.open("#{Rails.root}/app/views/problems/tips.yml"))
    @tips = all_tips[lens]["examples"]
    @intro_text = all_tips[lens]["intro_text"]
  end

  def check_user_access
    redirect_to problems_path if current_user.id != @problem.user.id
  end

  def problem_params
    params.require(:problem).permit(:name, :public, :adaptability,
      :cultural_competency, :empathy, :intellectual_curiosity, :thinking)
  end

  def set_redirect_path
    @redirect_path = review_problem_path(@problem.id)
    @redirect_path = problem_path(@problem) if params[:redirect_to_current_page]
  end

  def has_unfinish_problem?
    unfinish_problems = current_user.problems.unfinish_problem.first
    return false unless unfinish_problems.present?
    Problem::LENSES.each do |lens|
      unless unfinish_problems[lens].present?
        @unfinish_problem = { id: unfinish_problems.id, lens: lens }
        return true
      end
    end
  end

  def visit_ace_it_form
    # redirect to lens form if user didn't complete creating problem workflow
    redirect_to lenses_problem_path(
      id: @unfinish_problem[:id], lens: @unfinish_problem[:lens]
    ) if @unfinish_problem
  end

  def done_lens_form?(lens)
    lens == 'thinking'
  end

  def finish_lens_form
    redirect_to review_problem_path(@problem.id)
  end

  def visit_next_lens_form(lens)
    new_lens = "#{Problem.next_lens(lens)}"
    redirect_to lenses_problem_path(id: @problem.id, lens: new_lens)
  end
end
