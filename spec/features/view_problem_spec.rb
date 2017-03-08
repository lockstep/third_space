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

      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Delete'
      expect(page).to have_content 'Share'
    end
  end

  context 'other users' do
    scenario 'can not see problem problem' do
      login_as(@user2, scope: :user)
      visit problem_path(@problem)

      expect(page).to_not have_content 'Edit'
      expect(page).to_not have_content 'Delete'
      expect(page).to have_content 'Share'
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

  context 'Adding a comment' do
    scenario 'adds the comment successfully' do
      visit problem_path(@problem.id)
      value = 'hello world'
      fill_in 'comment_description', with: value
      expect(find('.comment__button--submit')['disabled']).to eq false
      click_on 'POST'
      expect(page).to have_content("#{@user2.first_name}: #{value}")
    end

    scenario "cannot post the comment" do
      visit problem_path(@problem.id)
      fill_in 'comment_description', with: '          '
      expect(find('.comment__button--submit')['disabled']).to eq true
    end
  end

  context 'Deletes a comment' do
    scenario 'deletes the comment successfully' do
      visit problem_path(@problem.id)

      expect(page).to have_content("#{@user2.first_name}: Hello, this is awesome.")

      accept_confirm do
        find('.comment__delete-icon').trigger('click')
      end
      expect(page).to_not have_content("#{@user2.first_name}: Hello, this is awesome.")
    end

    scenario 'edit the comment successfully' do
      visit problem_path(@problem.id)

      expect(page).to have_content("#{@user2.first_name}: Hello, this is awesome.")

      find('.comment__edit-icon').trigger('click')
      expect(page).to have_content "Edit Comment"
      fill_in 'edit-comment-input', with: 'Edited comment'
      click_on 'Edit'

      expect(page).to_not have_content("#{@user2.first_name}: Hello, this is awesome.")
      expect(page).to have_content("#{@user2.first_name}: Edited comment")
    end
  end

  context 'Shares a problem' do
    before { login_as(@user, scope: :user) }
    scenario 'shares via facebook' do
      visit problem_path(@problem.id)
      click_on 'Share'
      expect(page).to have_content 'Share Problem'
      new_window = window_opened_by { find('.btn--facebook').trigger('click') }
      expect(new_window).to_not be_nil
    end

    scenario 'shares via twitter' do
      visit problem_path(@problem.id)
      click_on 'Share'
      expect(page).to have_content 'Share Problem'
      new_window = window_opened_by { find('.btn--twitter').trigger('click') }
      expect(new_window).to_not be_nil
    end
  end
end
