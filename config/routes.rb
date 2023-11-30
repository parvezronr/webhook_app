Rails.application.routes.draw do
  post '/webhook/create', to: 'webhook#create'
  post '/webhook/update', to: 'webhook#update'
end
