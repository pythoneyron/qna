require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  describe 'Edit questions link' do
    given!(:question_with_link) { create(:question, :with_link, author: user) }

    scenario 'by author', js: true do
      sign_in(user)
      visit question_path(question_with_link)

      within '.question' do
        click_on 'Edit'
        expect(page).to have_link 'MyString', href: 'http://valid.com'

        fill_in 'Link name', with: 'New link name'
        fill_in 'Url', with: 'http://newurl.com'
        click_on 'Save'
        expect(page).to_not have_link 'MyString', href: 'http://valid.com'
        expect(page).to have_link 'New link name', href: 'http://newurl.com'
      end
    end

    scenario 'by user', js: true do
      sign_in(not_author)
      visit question_path(question_with_link)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user_author)
      visit(question_path(question))

      click_on('Edit the question')

      within '.question' do
        fill_in('Your title question', with: 'Edited question title')
        fill_in('Your body question', with: 'Edited question body')
        click_on('Save')

        expect(page).to_not(have_content(question.title))
        expect(page).to_not(have_content(question.body))
        expect(page).to(have_content('Edited question title'))
        expect(page).to(have_content('Edited question body'))
        expect(page).to_not(have_selector('textarea'))
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in(user_author)
      visit(question_path(question))

      click_on('Edit the question')

      within '.question' do
        fill_in('Your title question', with: '')
        fill_in('Your body question', with: '')
        click_on('Save')

        expect(page).to(have_content("Title can't be blank"))
        expect(page).to(have_content("Body can't be blank"))
        expect(page).to(have_selector('textarea'))
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit(question_path(question))
      expect(page).to_not(have_link( 'Edit the question' ))
    end

  end

  describe 'Unauthenticated user' do
    scenario 'can not edit question' do
      visit(question_path(question))
      expect(page).to_not(have_link( 'Edit the question' ))
    end
  end

end
