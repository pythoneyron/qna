Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true do
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
