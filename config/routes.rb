Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tickets#index"

  # API
  # (data input)
  namespace :api do
    namespace :v1 do
      post 'ticket_data', to: 'ticket_data#input'
    end
  end

  # Models
  get '/tickets', to: 'tickets#index'
  get '/tickets/:id', to: 'tickets#show', as: 'ticket'
end
