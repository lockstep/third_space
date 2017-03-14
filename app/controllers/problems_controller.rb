class ProblemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_problem, only: [
    :edit, :update, :destroy, :show, :lens, :update_lens, :review,
    :share_by_email
  ]
  before_action :check_user_access, only: [:edit, :lens, :review]

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
    visit_ace_it_form
    @problem = Problem.new
    load_tips('problem')
  end

  def create
    @problem = Problem.new(problem_params.merge(user_id: current_user.id))
    if @problem.save(problem_params)
      assign_cookies
      visit_ace_it_form
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
      redirect_to review_problem_path(@problem.id)
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

  def assign_cookies
    cookies[:problem_id] = @problem.id
    cookies[:lens] = "adaptability"
  end

  def destroy_cookies
    cookies.delete :problem_id
    cookies.delete :lens
  end

  def visit_ace_it_form
    # redirect to lens form if user didn't complete creating problem workflow
    redirect_to lenses_problem_path(
      id: cookies[:problem_id], lens: cookies[:lens]
    ) and return if cookies[:problem_id]
  end

  def done_lens_form?(lens)
    lens == 'thinking'
  end

  def finish_lens_form
    destroy_cookies
    redirect_to review_problem_path(@problem.id)
  end

  def visit_next_lens_form(lens)
    new_lens = "#{Problem.next_lens(lens)}"
    cookies[:lens] = new_lens
    redirect_to lenses_problem_path(id: @problem.id, lens: new_lens)
  end
end
