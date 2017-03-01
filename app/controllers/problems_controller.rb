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
    @problem = Problem.new
    load_tips('problem')
  end

  def create
    @problem = Problem.new(problem_params.merge(user_id: current_user.id))
    if @problem.save(problem_params)
      redirect_to "/problems/#{@problem.id}/lenses/adaptability"
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
      lense = params[:problem][:lense]
      if lense == 'thinking'
        redirect_to review_problem_path(@problem.id) and return
      else
        redirect_to lenses_problem_path(id: @problem.id, lense: "#{Problem.next_lens(lense)}")
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

end
