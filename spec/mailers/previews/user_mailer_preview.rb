# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def problem_with_solution
    problem = Problem.first
    receiver_email = "hello@gmail.com"
    UserMailer.problem_with_solution(problem.id, receiver_email)
  end
end
