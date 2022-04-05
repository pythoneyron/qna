Rails.application.routes.draw do
  devise_for :users
  concern :voted do
    member do
      put :vote_for
      put :vote_against
      delete :cancel_voting
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      get :mark_as_best, on: :member
    end
  end

  resources :files, only: %i[destroy]

  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :users, only: :rewards do
    member do
      get :rewards
    end
  end
end
