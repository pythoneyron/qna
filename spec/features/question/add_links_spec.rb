require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional into to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/pythoneyron/2f671860b4916fc7e7efc49636bad7f1' }

  scenario 'User adds link when ask question' do
    sign_in(user)
    visit new_question_path
    # visit questions_path

    fill_in 'Title', with: 'Text question'
    fill_in 'Body', with: 'Text Text Text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link "My gist", href: gist_url
  end

end
