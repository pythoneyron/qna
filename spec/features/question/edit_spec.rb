require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user_author)
      visit(question_path(question))

      click_on('Edit the question')

      # within '.question' do
        fill_in('Your question', with: 'Edited question')
        click_on('Save')

        expect(page).to_not(have_content(answer.body))
        expect(page).to(have_content('Edited question'))
        expect(page).to_not(have_selector('textarea'))
      # end
    end
  end
end
