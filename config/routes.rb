Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  scope module: :public do
    root to: "homes#top"

    resources :courses do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      resource :finishes, only: [:create, :destroy]
    end
    patch 'users/withdrawal', to: 'users#withdrawal', as: 'withdrawal'
    resources :users, only: [:show, :update] do
      resource :relationships, only:[:create, :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
