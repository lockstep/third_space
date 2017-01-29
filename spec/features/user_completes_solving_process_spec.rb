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

  scenario 'creates new submission', js: true do
    visit '/problems/new'
    find(:href, "new-problem-textarea").trigger('click')
    fill_in 'new-problem-input', with: 'New submission'
    click_on 'Next'
    expect(page).to have_content 'What is a solution through this lens?'
    expect(page).to have_content 'What is your expected result?'
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

    scenario 'finalizes submission', js: true do
      Input::LENSES.each do |lens|
        create(:input, lens: lens, input_type: 'result', problem: @problem)
        create(:input, lens: lens, input_type: 'solution', problem: @problem)
      end
      visit "/problems/#{@problem.id}/adaptability"
      find(:href, "solution-textarea").trigger('click')
      wait_for_ajax
      click_on 'Next'
    end

    scenario 'submits final review', js: true do
      visit "/problems/#{@problem.id}/review"
      find(:href, "review-textarea").trigger('click')
      wait_for_ajax
      fill_in "review-input", with: 'Final text'
      find(:href, "review-textarea").trigger('click')
      wait_for_ajax
      visit "/problems/#{@problem.id}/review"
      find(:href, "review-textarea").trigger('click')
      wait_for_ajax
      expect(page).to have_field("review-input", with: 'Final text')
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
