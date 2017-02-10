require 'rails_helper'

feature 'Discuss Feed' do
  background do
    @user = create(:user)
    @user2 = create(:user, email: 'test@mail.com')
    @problem = create(:problem, user: @user)
    @input = create(:input, lens: 'thinking', problem: @problem)
    @comment = create(:comment, problem: @problem, user: @user2)

    login_as(@user2, scope: :user)
  end

  scenario 'sees discuss page with comment' do
    visit "/problems/#{@problem.id}/discuss"
    expect(page).to have_content('TST DISCUSS')
    expect(page).to have_content(@problem.name)
    expect(page).to have_content(@input.input_text)
    expect(page).to have_content(@comment.description)
  end

  scenario 'adds comment on discuss page' do
    visit "/problems/#{@problem.id}/discuss"
    value = 'hello world'
    fill_in 'comment_description', with: value
    click_on 'POST'
    expect(page).to have_content("#{@user2.email}: #{value}")
  end
end
