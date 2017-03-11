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

  def remove_unwanted_words(string)
    bad_words = ["less than", "about"]
    bad_words.each do |bad|
      string.gsub!(bad + " ", '')
    end
    string
  end

  def voted?(user_id, problem_id)
    solution_user_like = SolutionLike.find_by(user_id: user_id, problem_id: problem_id)
    return false unless solution_user_like.present?
    solution_user_like.liked
  end
end
