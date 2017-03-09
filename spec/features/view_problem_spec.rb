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
    end

    scenario 'cannot see unpublic problem' do
      visit problem_path(@problem)
      expect(page).to_not have_content @problem.name.upcase
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
