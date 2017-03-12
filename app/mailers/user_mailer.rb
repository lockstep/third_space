class UserMailer < ApplicationMailer
  before_action :attach_header_image

  def problem_with_solution(problem_id, receiver_email)
    @problem = Problem.find(problem_id)
    mail(to: receiver_email,
      bcc: ['shellee.smith@usc.edu', 'paul@locksteplabs.com'],
      subject: 'New Problem With Solution'
    )
  end

  private

  def attach_header_image
    attachments.inline['thirdspace_header_email.png'] = File.read(
      "#{Rails.root}/app/assets/images/thirdspace_header_email.png"
    )
  end
end
