require 'rails_helper'

feature 'View Problem', js: true do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
    @comment = create(:comment, problem: @problem, user: @user2)
    login_as(@user2, scope: :user)
  end

  context 'owner problem' do
    scenario 'can see problem actions' do
      login_as(@user, scope: :user)
      visit problem_path(@problem)

      expect(page).to have_css '.problem__btn--edit'
      expect(page).to have_css '.problem__btn--destroy'
      expect(page).to have_link 'Like'
      expect(page).to have_button 'Share'
    end
  end

  context 'other users' do
    scenario 'can not see problem problem' do
      login_as(@user2, scope: :user)
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
      visit problems_path
      click_link 'Logout'
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

    context 'singin to comment problem' do
      scenario 'redirects to problems show path' do
        visit problem_path(@problem2)
        click_on 'Sign In'
        fill_in 'user[email]', with: @user2.email
        fill_in 'user[password]', with: 'password'
        click_on 'Sign in'
        expect(page).to have_content @problem.name.upcase
        expect(current_url).to "/problems/#{@problem2.id}"
      end
    end

    context 'signup to comment problem' do
    end
  end

  scenario 'sees problem page with comment' do
    visit problem_path(@problem.id)
    expect(page).to have_content(@problem.name.upcase)
    expect(page).to have_content(@problem.thinking)
    expect(page).to have_content(@comment.description)
  end

  scenario 'disables post button by default' do
    visit problem_path(@problem.id)
    expect(find('.comment__button--submit')['disabled']).to eq true
  end
end
