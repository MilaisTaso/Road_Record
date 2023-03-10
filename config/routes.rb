Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }
  
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in', as:'guest_sign_in'
  end

  scope module: :public do
    root to: "homes#top"

    resources :courses do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      resource :finishes, only: [:create, :destroy]
    end
    patch 'users/withdrawal', to: 'users#withdrawal'
    resources :users, only: [:show, :update,] do
      resource :relationships, only:[:create, :destroy]
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :destroy] do
      patch 'withdrawal', to:'users#withdrawal', as: 'withdrawal'
    end
    resources :courses, only: [:index, :show, :destroy]
    get '/', to: 'users#index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
