module ProblemHelper
  def get_lense_submit_text(lense)
    lense_text = Problem.next_lens(lense).humanize.titleize
    return "Continue to #{lense_text}" if !['thinking', 'intellectual_curiosity'].include? lense

    return 'Continue to 360 Degree Thinking' if lense == 'intellectual_curiosity'
    return 'Complete'
  end

  def show_problem_actions?(user)
    user == current_user
  end
end
