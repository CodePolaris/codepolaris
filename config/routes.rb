Polaris::Application.routes.draw do

  root 'application#home'

  get '/home' => 'application#home', as: :home
  post '/home' => 'application#send_contact_email', as: :send_contact_email
  get '/set_locale' => 'application#set_locale', as: :set_locale

  match "*path", to: "application#routing_error", via: :all
end
