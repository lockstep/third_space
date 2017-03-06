module ProblemHelper
  def get_lens_submit_text(lens)
    lens_text = Problem.next_lens(lens).humanize.titleize
    return "Continue to #{lens_text}" if !['thinking', 'intellectual_curiosity'].include? lens

    return 'Continue to 360 Degree Thinking' if lens == 'intellectual_curiosity'
    return 'Complete'
  end

  def show_problem_actions?(user)
    user == current_user
  end
end
