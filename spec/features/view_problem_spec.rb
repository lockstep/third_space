require 'rails_helper'

feature 'View Problem' do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
    @comment = create(:comment, problem: @problem, user: @user2)
    login_as(@user2, scope: :user)
  end

  scenario 'views problem page with comment' do
    visit problem_path(@problem.id)
    expect(page).to have_content(@problem.name)
    expect(page).to have_content(@problem.thinking)
    expect(page).to have_content(@comment.description)
  end

  scenario 'adds a comment to the problem' do
    visit problem_path(@problem.id)
    value = 'hello world'
    fill_in 'comment_description', with: value
    click_on 'POST'
    expect(page).to have_content("#{@user2.email}: #{value}")
  end
end
