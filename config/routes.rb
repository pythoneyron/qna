Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow: true do
    resources :answers, shallow: true do
      get :mark_as_best
    end
  end

  root to: 'questions#index'
end
