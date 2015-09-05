Rails.application.routes.draw do
  root 'application#root'

  namespace :api do
    namespace :v1 do
      get 'verify_authentication' => 'api#verify_authentication'

      resources :tickets, only: [:index, :show] do
      end

      namespace :sportsbook do
        get 'recent_tickets'
        get 'all_tickets'
      end

    end
  end

# Migrate from Go
    # &rest.Route{"POST", "/tickets/:ticket_id/ticket_tags", handlers.CreateTicketTag},
    # &rest.Route{"DELETE", "/tickets/:ticket_id/ticket_tags/:ticket_tag_id", handlers.DeleteTicketTag},
    # &rest.Route{"GET", "/finances", handlers.GetFinances},
    # &rest.Route{"GET", "/tags", handlers.GetTags},

end
