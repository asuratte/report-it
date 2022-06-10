Rails.application.routes.draw do
  resources :reports
  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  authenticate :user, -> (user) { user.is_resident? } do
    get 'resident', to: 'resident#index'
  end
  
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
