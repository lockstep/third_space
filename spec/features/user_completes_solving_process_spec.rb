require 'rails_helper'

feature 'User completes solving process' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end
  scenario 'skips the intro wizard' do
    visit '/'
    click_on 'Skip'
    expect(page).to have_content('Write problem name here')
  end

  context 'creates new submission' do
    background { visit '/problems/new' }
    scenario 'with text', js: true do
      find(:href, "new-problem-textarea").trigger('click')
      fill_in 'new-problem-input', with: 'New submission'
      click_on 'Next'
      expect(page).to have_content 'What is a solution through this lens?'
      expect(page).to have_content 'What is your expected result?'
    end
  end

  context 'existing submissions' do
    background do
      @problem = create(:problem, user: @user)
    end

    context 'successfully updates lens' do
      Input::LENSES.each do |lens|
        scenario lens, js: true do
          test_lens(lens)
        end
      end
    end

    scenario 'filters by all' do
      another_user = create(:user, email: 'foo@example.com')
      create(:problem, name: 'Another problem', user: @user)
      create(:problem, name: "Somebody else's problem", user: another_user)

      visit '/problems'
      expect(page).to have_content('My Problem')
      expect(page).to have_content('Another problem')
      expect(page).not_to have_content("Somebody else's problem")

      visit '/problems?stream=all'
      expect(page).to have_content("Somebody else's problem")
    end

    scenario 'edits from search' do
    end
  end

  def test_lens(lens)
    @input = create(:input, problem: @problem, lens: lens)
    visit "/problems/#{@problem.id}/#{@input.lens}"
    test_input('solution')
    test_input('result')
  end

  def test_input(type)
    find(:href, "#{type}-textarea").trigger('click')
    wait_for_ajax
    fill_in "#{type}-input", with: 'Updated text'
    find(:href, "#{type}-textarea").trigger('click')
    wait_for_ajax
    expect(page).to have_field("#{type}-input", with: 'Updated text')
  end
end
