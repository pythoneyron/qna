require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional into to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/pythoneyron/2f671860b4916fc7e7efc49636bad7f1' }
  given(:github_url) { 'https://github.com' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'New answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    within '.nested-fields' do
      fill_in 'Link name', with: 'Github'
      fill_in 'Url', with: github_url
    end

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link "My gist", href: gist_url
      expect(page).to have_link 'Github', href: github_url
    end
  end

end
