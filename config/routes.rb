Rails.application.routes.draw do
  resources :reports
  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  root to: 'home#index'
  get 'test/index' => 'home#index'
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
