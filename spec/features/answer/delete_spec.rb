require 'rails_helper'

feature 'Author can delete his answer', "
  In order to delete my answer
  As an authenticated user
  I'd like to be able to delete my answer
" do

  given(:user_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given(:answer) { create(:answer, question: question, author: user_author) }

  describe 'Authenticated' do
    scenario 'author can delete his answer', js: true do
      sign_in(answer.author)
      visit question_path(answer.question)
      expect(page).to have_content answer.body

      click_on 'Delete the answer'
      expect(page).to_not have_content(answer.body)
    end

    scenario "user can't destroy other user's answer", js: true do
      sign_in(user)
      visit question_path answer.question
      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't destroy any answer", js: true do
      visit question_path answer.question
      expect(page).to_not have_link 'Delete answer'
    end
  end
end