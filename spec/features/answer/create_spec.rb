require 'rails_helper'

feature 'User can create answer', %q{
  In order to get question from a community
  As an authenticated user
  I`d like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create an answer', js: true do
      fill_in 'Body', with: 'New answer'
      click_on 'Create'

      expect(page).to have_content 'New answer'
    end

    scenario 'creates answer with errors', js: true do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'view the question and answers to it', js: true do
      fill_in 'Body', with: 'New answer'
      click_on 'Create'

      fill_in 'Body', with: 'New answer1'
      click_on 'Create'

      fill_in 'Body', with: 'New answer2'
      click_on 'Create'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'New answer'
      expect(page).to have_content 'New answer1'
      expect(page).to have_content 'New answer2'
    end

    scenario 'an answers with attached file', js: true do
      fill_in 'Body', with: 'New answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not create an answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Create'
    end
  end
end
