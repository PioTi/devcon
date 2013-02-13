Devcon::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users
  resources :users, :only => [:show]

  devise_scope :user do
    get 'login', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    get 'register', :to => 'devise/registrations#new', :as => :new_user_registration
    get 'settings', :to => 'devise/registrations#edit', :as => :edit_user_registration
  end

  resources :articles do
    resources :comments, :except => [:new]
  end

  resources :events do 
    collection do
      get :previous
    end
    resources :event_partners, :except => [:index, :show]
    resources :participants, :except => [:index, :show]
  end
  resources :partners, :only => [:index, :show]
  resources :resource_people
  resources :venues

  resources :entities
  resources :categories
  resources :tags

  match '/contact', :to => 'static_pages#contact'
  match '/about',   :to => 'static_pages#about'
  match '/feed' => 'static_pages#feed',
      :as => :feed,
      :defaults => { :format => 'atom' }

  root :to => 'static_pages#home'
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'static_pages#error_404'
  end
end
