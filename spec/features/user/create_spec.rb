require 'rails_helper'

feature 'User can register and auth', %q{
  In order to get question from a community
  As an authenticated user
  I`d like to be able to ask the question
} do

  given(:user) { create(:user) }

  scenario 'User can register' do
    visit root_path
    click_on 'registration'

    fill_in 'Email', with: 'new_user@mail.com'
    fill_in 'Password', with: '123qwe123'
    fill_in 'Password confirmation', with: '123qwe123'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content 'new_user@mail.com'
  end

  scenario 'User can sign in' do
    visit root_path
    click_on 'sign in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content user.email
  end

  scenario 'User can sign out' do
    sign_in(user)
    visit root_path
    click_on 'sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'User can sign in with errors' do
    visit root_path
    click_on 'sign in'

    fill_in 'Email', with: nil
    fill_in 'Password', with: nil
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  given!(:questions) { create_list(:question, 5, author: user) }
  scenario 'Unauthenticated user tries view list the questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user tries asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
