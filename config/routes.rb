Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#destroy'
      get 'sessions', to: 'sessions#show'
      get 'csrf_token', to: 'sessions#csrf_token'
    end

    namespace :v1 do
      resources :users
      resources :articles do
        collection do
          get :my_articles
        end
        member do
          patch :approve
          patch :publish
        end
      end
      resources :categories
    end
  end
end
