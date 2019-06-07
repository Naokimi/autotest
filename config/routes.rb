Rails.application.routes.draw do
  devise_for :teachers
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :exams, only: [:new, :create, :show, :edit, :update, :index, :destroy] do
    resources :questions, only: [:new, :create, :index]
    resources :submissions, only: [:new, :create, :index]
    resources :answers, only: [:index]
  end
  resources :questions, only: [:show]
  resources :answers, only: [:edit, :update]
  resources :submissions, only: [:show] do
    resources :answers, only: [:new, :create]
  end
end
