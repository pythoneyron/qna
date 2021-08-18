require 'rails_helper'

feature 'User can create answer', %q{
  In order to get question from a community
  As an authenticated user
  I`d like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'write an answer to the question' do
      visit question_path(question)

      fill_in 'Body', with: 'New answer'
      click_on 'To answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'New answer'
    end

    scenario 'view the question and answers to it' do
      visit question_path(question)

      fill_in 'Body', with: 'New answer'
      click_on 'To answer'
      expect(page).to have_content 'Your answer successfully created.'

      fill_in 'Body', with: 'New answer1'
      click_on 'To answer'
      expect(page).to have_content 'Your answer successfully created.'

      fill_in 'Body', with: 'New answer2'
      click_on 'To answer'
      expect(page).to have_content 'Your answer successfully created.'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'New answer'
      expect(page).to have_content 'New answer1'
      expect(page).to have_content 'New answer2'
    end

    scenario 'create an answer' do
      visit question_path(question)
      expect(page).to_not have_content 'To answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'write an answer to the question' do
      visit question_path(question)
      fill_in 'Body', with: 'New answer'
      click_on 'To answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
