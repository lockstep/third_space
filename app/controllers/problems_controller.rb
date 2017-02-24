class ProblemsController < ApplicationController
  before_action :set_problem, only: [:update, :show, :lense, :update_lense, :success, :edit]

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
    all_tips = load_tips("problem")
    @problem = Problem.new
    @tips = all_tips["examples"]
    @intro_text = all_tips["intro_text"]
  end

  def create
    problem = Problem.new(problem_params.merge(user_id: current_user.id))
    if problem.save(problem_params)
      redirect_to "/problems/#{problem.id}/lenses/adaptability"
    else
      redirect_to :back
    end
  end

  def edit
    all_tips = load_tips("problem")
    @tips = all_tips["examples"]
    @intro_text = all_tips["intro_text"]
  end

  def update
    if @problem.update(problem_params)
      redirect_to success_problem_path(@problem.id)
    else
      redirect_to :back
    end
  end

  def show
    lense_index = params[:id].to_i % Problem::LENSES.length
    @lense = Problem::LENSES[lense_index]
    @image_index = (params[:id].to_i  % TEXTURE_IMAGE_AMOUNT) + 1
  end

  def lense
    @lense = params[:lense]
    all_tips = load_tips(@lense)
    @tips = all_tips["examples"]
    @intro_text = all_tips["intro_text"]
  end

  def update_lense
    if @problem.update(problem_params)
      lense = params[:problem][:lense]
      redirect_to success_problem_path(@problem.id) and return if lense == 'thinking'
      redirect_to lenses_problem_path(id: @problem.id, lense: "#{Problem.next_lens(lense)}")
    else
      redirect_to :back
    end
  end

  def success
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def load_tips(lense)
    all_tips = YAML.load_file(File.open("#{Rails.root}/app/views/problems/tips.yml"))
    all_tips[lense]
  end

  def problem_params
    params.require(:problem).permit(:name, :public, :adaptability,
      :cultural_competence, :empathy, :intellectual_curiosity, :thinking)
  end

end
