require 'rails_helper'

describe ProblemsController do
  include ActiveJob::TestHelper

  describe 'POST share_by_email' do
    context 'user logged in' do
      login_user

      it 'sends email to Sidekiq' do
        @problem = create(:problem, user: @user)
        expect {
          perform_enqueued_jobs do
            post :share_by_email, params: { id: @problem.id, problem: { email: 'hello@gmail.com'} }
          end
        }.to change{ ActionMailer::Base.deliveries.size }.by(1)
      end
    end
  end
end
