Rails.application.routes.draw do
  resources :reports
  devise_for :users, :path_prefix => 'account', :controllers => {
    registrations: 'registrations'
  }
  authenticate :user, -> (user) { user.is_admin? } do
    resources :users
  end

  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
