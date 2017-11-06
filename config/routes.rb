Rails.application.routes.draw do
  get 'getaddress' => 'home#index', as: :home

  root to: "home#index"

  namespace :apis do
    mount CoreAPI => 'core'
  end
end
