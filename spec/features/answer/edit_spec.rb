require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user_author)
      visit(question_path(question))

      click_on('Edit')

      within '.answers' do
        fill_in('Your answer', with: 'Edited answer')
        click_on('Save')

        expect(page).to_not(have_content(answer.body))
        expect(page).to(have_content('Edited answer'))
        expect(page).to_not(have_selector('textarea'))
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(user_author)
      visit(question_path(question))

      click_on('Edit the question')

      within '.answers' do
        fill_in('Your answer', with: '')

        expect(page).to(have_content(answer.body))
        expect(page).to(have_content("Body can't be blank"))
        expect(page).to(have_selector('textarea'))
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit(question_path(question))

      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit answer' do
      visit question_path(question)
      expect(page).to_not have_link('Edit')
    end
  end

end