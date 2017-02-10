require 'rails_helper'

feature 'Discuss Feed' do
  background do
    @user = create(:user)
    @user2 = create(:user, email: 'test@mail.com')
    @problem = create(:problem, user: @user)
    @comment = create(:comment, problem: @problem, user: @user2)

    login_as(@user2, scope: :user)
  end

  scenario 'visits discuss page with comment' do
    visit "/problems/#{@problem.id}/discuss"
    expect(page).to have_content('TST DISCUSS')
    expect(page).to have_content(@comment.description)
    expect(page).to have_content(@problem.name)
  end

  scenario 'adds comment on discuss page' do
    visit "/problems/#{@problem.id}/discuss"
    fill_in 'comment_description', with: 'hello world'
    click_on 'POST'

    expect(page).to have_content("#{@user2.email}: hello world")
  end
end
