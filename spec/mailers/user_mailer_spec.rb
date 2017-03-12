require "rails_helper"

describe UserMailer do
  describe '#problem_with_solution' do
    before do
      @user = create(:user)
      @problem = create(:problem, user: @user)
      @receiver_email = 'logan@gmail.com'
      @mail = UserMailer.problem_with_solution(@problem.id, @receiver_email)
    end

    it 'renders the subject' do
      expect(@mail.subject).to match('New Problem With Solution')
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@receiver_email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['no-reply@uscthirdspace.com'])
    end

    it 'renders the bcc email' do
      expect(@mail.bcc).to eq(['shellee.smith@usc.edu', 'paul@locksteplabs.com'])
    end

    it 'renders content correctly' do
      expect(@mail.body.encoded).to match(@user.full_name)
      expect(@mail.body.encoded).to have_link('Check out my solution', href: problem_url(@problem))
    end
  end
end
