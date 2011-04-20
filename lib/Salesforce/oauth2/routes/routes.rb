# This is a template for the Route file
OmniauthDemo::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  #add our oauth redirect route - qw
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#fail'
end

#TODO, need to dynamically add to the Application's Route class.