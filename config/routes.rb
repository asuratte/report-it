Rails.application.routes.draw do
  resources :reports do
    member do
      delete 'delete_image/:image_id', to: 'reports#delete_image', as: 'delete_image'
    end
  end

  devise_for :users, :path_prefix => 'account', :controllers => {
    registrations: 'registrations'
  }
  authenticate :user, -> (user) { user.is_admin? } do
    resources :users
    resources :themes, except: [:create, :new, :destroy]
    resources :contents, except: [:create, :new, :destroy]
  end

  authenticate :user, -> (user) { user.is_resident? } do
    get 'resident', to: 'resident#index'
  end

  authenticate :user, -> (user) { user.is_official? || user.is_admin? } do
    get 'official', to: 'official#index'
  end

  authenticate :user, -> (user) { user.is_admin? } do
    get 'deactivated-reports', to: 'deactivated_reports#index'
    get 'flagged-reports', to: 'flagged_reports#index'
  end

  root to: 'home#index'

  post '/reports/:id/edit' => 'reports#edit'

  get '*path', to: redirect('/'), constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
