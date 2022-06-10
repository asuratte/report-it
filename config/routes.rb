Rails.application.routes.draw do
  resources :reports
  devise_for :users, :path_prefix => 'account', :controllers => {
    registrations: 'registrations'
  }
  authenticate :user, -> (user) { user.is_admin? } do
    resources :users
  end

  authenticate :user, -> (user) { user.is_resident? } do
    get 'resident', to: 'resident#index'
  end
  
  root to: 'home#index'
  get 'test/index' => 'home#index'
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
