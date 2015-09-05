Rails.application.routes.draw do
  root 'application#root'

  namespace :api do
    namespace :v1 do
      get 'verify_authentication' => 'api#verify_authentication'

      resources :tickets, only: [:index, :show], param: :ticket_id do
        member do
          resources :ticket_tags, only: [:create, :destroy]
        end
      end

      resources :tags, only: [:index]

      namespace :sportsbook do
        get 'recent_tickets'
        get 'all_tickets'
      end

    end
  end

# Migrate from Go
    # &rest.Route{"GET", "/finances", handlers.GetFinances},

end
