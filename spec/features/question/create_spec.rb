require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I`d like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 5) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Text question'
      fill_in 'Body', with: 'Text Text Text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Your question'
      expect(page).to have_content 'Text Text Text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'view list the questions' do
      questions

      visit questions_path

      questions.each do |question|
        expect(page).to have_content question.id
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end
  end

  scenario 'Unauthenticated user tries view list the questions' do
    questions

    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.id
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'Unauthenticated user tries asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
