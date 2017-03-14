require 'rails_helper'

feature 'View Problem', js: true do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
  end

  context 'owner problem' do
    before { login_as(@user, scope: :user) }

    scenario 'can see problem actions' do
      visit problem_path(@problem)
      expect(page).to have_css '.problem__btn--edit'
      expect(page).to have_css '.problem__btn--destroy'
      expect(page).to have_link 'Like'
      expect(page).to have_button 'Share'
    end

    context 'uncompleted problem' do
      before do
        @uncompleted_problem = Problem.create(name: 'Hello World', user: @user)
      end
      scenario 'can continue to fill_in ACE-IT form' do
        visit problem_path(@uncompleted_problem)
        expect(page).to have_content 'Continue'
        expect(page).to_not have_css '.problem__btn--edit'
        expect(page).to_not have_css '.problem__btn--destroy'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_button 'Share'
      end
    end
  end

  context 'other users' do
    context 'authenticated user' do
      before { login_as(@user2, scope: :user) }
      scenario 'can not see problem actions' do
        visit problem_path(@problem)

        expect(page).to_not have_css '.problem__btn--edit'
        expect(page).to_not have_css '.problem__btn--destroy'
        expect(page).to have_link 'Like'
        expect(page).to have_button 'Share'
      end
    end

    context 'unauthenicated user' do
      before do
        @problem2 = create(:problem, public: true, user: @user)
      end

      scenario 'can see public problem' do
        visit problem_path(@problem2)
        expect(page).to have_content @problem2.name.upcase
        expect(page).to have_link 'Sign In'
        expect(page).to have_link 'Create Account'
        expect(page).to_not have_link 'Profile'
        expect(page).to_not have_link 'Logout'
        expect(page).to_not have_content 'Feed'
      end

      scenario 'cannot see unpublic problem' do
        visit problem_path(@problem)
        expect(page).to_not have_content @problem.name.upcase
      end

      context 'user visit problem show page' do
        before { visit problem_path(@problem2) }

        scenario 'redirects to problems show path after sign-in' do
          click_on 'Sign In'
          fill_in 'user[email]', with: @user2.email
          fill_in 'user[password]', with: 'password'
          click_on 'Sign in'
          expect(page).to have_content @problem2.name.upcase
          expect(current_url).to match "/problems/#{@problem2.id}"
        end

        scenario 'redirects to problems show path after sign-up' do
          click_on 'Create Account'
          fill_in 'user[first_name]', with: 'peter'
          fill_in 'user[last_name]', with: 'thiel'
          fill_in 'user[email]', with: 'peter.thiel@gmail.com'
          fill_in 'user[password]', with: '123456'
          fill_in 'user[password_confirmation]', with: '123456'
          click_on 'Sign up'
          expect(page).to have_content @problem2.name.upcase
          expect(current_url).to match "/problems/#{@problem2.id}"
        end
      end
    end
  end
end
