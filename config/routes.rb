Rails.application.routes.draw do
  resources :contents
  resources :reports
  devise_for :users, :path_prefix => 'account', :controllers => {
    registrations: 'registrations'
  }
  authenticate :user, -> (user) { user.is_admin? } do
    resources :users
    resources :themes, except: [:create, :new, :destroy]
  end

  authenticate :user, -> (user) { user.is_resident? } do
    get 'resident', to: 'resident#index'
  end

  authenticate :user, -> (user) { user.is_official? || user.is_admin? } do
    get 'official', to: 'official#index'
  end

  root to: 'home#index'

  post '/reports/:id/edit' => 'reports#edit'

  get '*path' => redirect('/')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
