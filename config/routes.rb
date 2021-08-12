Rails.application.routes.draw do
  resources :questions, shallow: true do
    resource :answers
  end
end
