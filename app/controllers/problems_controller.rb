class ProblemsController < ApplicationController
  before_action :set_problem, only: [
    :edit, :update, :destroy, :show, :lense, :update_lense, :review
  ]

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
    lense_index = params[:id].to_i % Problem::LENSES.length
    @lense = Problem::LENSES[lense_index]
    @image_index = (params[:id].to_i  % TEXTURE_IMAGE_AMOUNT) + 1
  end

  def destroy
    if @problem.destroy
      redirect_to problems_path
    end
  end

  def lense
    @lense = params[:lense]
    load_tips(@lense)
  end

  def update_lense
    if @problem.update(problem_params)
      if done_lense_form?(params[:problem][:lense])
        finish_lense_form
      else
        visit_next_lense_form(params[:problem][:lense])
      end
    else
      redirect_back(fallback_location: problems_path)
    end
  end

  def review
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def load_tips(lense)
    all_tips = YAML.load_file(File.open("#{Rails.root}/app/views/problems/tips.yml"))
    @tips = all_tips[lense]["examples"]
    @intro_text = all_tips[lense]["intro_text"]
  end

  def problem_params
    params.require(:problem).permit(:name, :public, :adaptability,
      :cultural_competence, :empathy, :intellectual_curiosity, :thinking)
  end

  def assign_cookies
    cookies[:problem_id] = @problem.id
    cookies[:lense] = "adaptability"
  end

  def destroy_cookies
    cookies.delete :problem_id
    cookies.delete :lense
  end

  def visit_ace_it_form
    # redirect to lense form if user didn't complete creating problem workflow
    redirect_to lenses_problem_path(
      id: cookies[:problem_id], lense: cookies[:lense]
    ) and return if cookies[:problem_id]
  end

  def done_lense_form?(lense)
    lense == 'thinking'
  end

  def finish_lense_form
    destroy_cookies
    redirect_to review_problem_path(@problem.id)
  end

  def visit_next_lense_form(lense)
    new_lense = "#{Problem.next_lens(lense)}"
    cookies[:lense] = new_lense
    redirect_to lenses_problem_path(id: @problem.id, lense: new_lense)
  end
end
