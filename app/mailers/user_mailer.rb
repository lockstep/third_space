class UserMailer < ApplicationMailer
  def problem_with_solution(problem_id, receiver_email)
    @problem = Problem.find(problem_id)
    mail(to: receiver_email,
      bcc: ['shellee.smith@usc.edu', 'paul@locksteplabs.com'],
      subject: 'New Problem With Solution'
    )
  end
end
