require 'rails_helper'

feature 'Create Comment', js: true do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
    login_as(@user2, scope: :user)
  end

  scenario 'disables post button by default' do
    visit problem_path(@problem.id)
    expect(find('.comment__button--submit')['disabled']).to eq true
  end
  
  scenario 'creates comment successfully' do
    visit problem_path(@problem.id)
    value = 'hello world'
    fill_in 'comment_description', with: value
    expect(find('.comment__button--submit')['disabled']).to eq false
    click_on 'POST'
    expect(page).to have_content value
  end

  scenario "cannot create comment" do
    visit problem_path(@problem.id)
    fill_in 'comment_description', with: '          '
    expect(find('.comment__button--submit')['disabled']).to eq true
  end
end
