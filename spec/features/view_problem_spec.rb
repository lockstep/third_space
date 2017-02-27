require 'rails_helper'

feature 'View Problem', js: true do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
    @comment = create(:comment, problem: @problem, user: @user2)
    login_as(@user2, scope: :user)
  end

  scenario 'sees problem page with comment' do
    visit problem_path(@problem.id)
    expect(page).to have_content(@problem.name.upcase)
    expect(page).to have_content(@problem.thinking)
    expect(page).to have_content(@comment.description)
  end

  scenario 'disables post button by default' do
    visit problem_path(@problem.id)
    expect(find('.btn__submit')['disabled']).to eq true
  end

  context 'Adding a comment' do
    scenario 'adds the comment successfully' do
      visit problem_path(@problem.id)
      value = 'hello world'
      fill_in 'comment_description', with: value
      expect(find('.btn__submit')['disabled']).to eq false
      click_on 'POST'
      expect(page).to have_content("#{@user2.email}: #{value}")
    end

    scenario "cannot post the comment" do
      visit problem_path(@problem.id)
      fill_in 'comment_description', with: '          '
      expect(find('.btn__submit')['disabled']).to eq true
    end
  end
end
