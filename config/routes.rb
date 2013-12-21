Aspirations::Application.routes.draw do
  resources :users, :only => [:new, :create, :show]
  resource :session, :only => [:new, :create, :destroy]
  resources :goals, :except => :index do
    resources :cheers, :only => :create
  end
end
