require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer from a community
  As an authenticated user
  I`d like to be able to ask the question
} do

  given(:user) { create(:user) }
  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'write an answer to the question'
    scenario 'view the question and answers to it'

  end
end
