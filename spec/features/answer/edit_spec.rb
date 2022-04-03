require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given(:question_with_answer) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  describe 'Edit answers link' do
    given!(:answer_with_link) { create(:answer, :with_link, question: question_with_answer, author: user) }

    scenario 'by author', js: true do
      sign_in(user)
      visit question_path(answer_with_link.question)
      click_on 'Edit'
      within ".answers" do

        expect(page).to have_link 'MyString', href: 'http://valid.com'

        fill_in 'Link name', with: 'New link name'
        fill_in 'Url', with: 'http://newurl.com'
        click_on 'Save'
      end
      expect(page).to_not have_link 'MyString', href: 'http://valid.com'
      expect(page).to have_link 'New link name', href: 'http://newurl.com'
    end

    scenario 'by user', js: true do
      sign_in(not_author)
      visit question_path(answer_with_link.question)
      within ".answers" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user_author)
      visit question_path(question)

      click_on('Edit')

      within '.answers' do
        fill_in('Your answer', with: 'Edited answer')
        click_on('Save')

        expect(page).to_not have_content(answer.body)
        expect(page).to have_content('Edited answer')
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(user_author)
      visit question_path(question)

      click_on('Edit')

      within '.answers' do
        fill_in('Your answer', with: '')
        click_on 'Save'

        expect(page).to have_content(answer.body)
        expect(page).to have_content("Body can't be blank")
        expect(page).to have_selector('textarea')
      end
    end

    scenario 'set answer as best', js: true do
      sign_in(user_author)
      visit question_path(question)

      click_on('Mark as best')

      expect(page).to have_content("The best answer")
    end

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit(question_path(question))

      expect(page).to_not have_link 'Edit'
    end

    scenario 'set answer as best' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content('Mark as best')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit answer' do
      visit question_path(question)
      expect(page).to_not have_link('Edit')
    end

    scenario 'can not set answer as best' do
      visit question_path(question)
      expect(page).to_not have_content('Mark as best')
    end
  end

  def link_id(item)
    item.links.first.id
  end

end