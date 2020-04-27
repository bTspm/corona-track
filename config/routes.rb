Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "corona#home"

  namespace :corona do
    get :countries_list
    get :countries_stats
    get :country_time_series
    get :country
    get :global_time_series
    get :state_stats
  end
end
