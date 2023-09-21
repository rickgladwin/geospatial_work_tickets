Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # API
  # (data input)
  post 'api/v1/ticket_data', to: 'api/v1/ticket_data#input'
end
