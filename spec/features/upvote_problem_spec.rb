require 'rails_helper'

feature 'Upvote Problem' do
  background do
    @user = create(:user)
    @problem = create(:problem, user: @user)
    login_as(@user, scope: :user)
  end

  context 'upvote 1 time' do
    scenario 'upvotes problem successfully' do
      visit problem_path(@problem.id)
      click_on 'Like'
      expect(page).to have_content '1 like'
    end

    scenario 'change like button to liked after voted' do
      visit problem_path(@problem.id)
      click_on 'Like'
      expect(page).to have_link 'Liked'
    end
  end

  context 'upvote 2 time' do
    context 'owner user like problem' do
      before do
        visit problem_path(@problem.id)
        click_on 'Like'
      end
      context 'another user login' do
        before do
          @user_2 = create(:user)
          login_as(@user_2, scope: :user)
        end
        scenario 'upvotes problem successfully' do
          visit problem_path(@problem.id)
          click_on 'Like'
          expect(page).to have_content '2 likes'
        end
      end
    end
  end
end
