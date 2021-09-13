Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    get 'destroy_file/:file_id', to: 'questions#destroy_file', on: :member, as: :destroy_file
    resources :answers, shallow: true do
      get 'destroy_file/:file_id', to: 'answers#destroy_file', on: :member, as: :destroy_file
      get :mark_as_best, on: :member
    end
  end

  root to: 'questions#index'
end
