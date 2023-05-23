require 'sidekiq/web'

Rails.application.routes.draw do
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => "/sidekiq"

  resources :grants do
    resources :resources do
      # get run_check
      resource :statuses
    end
  end

  resources :resources

  get '/grants/:id/resources/:resource_id/run_check', to: 'resources#run_check', as: :resource_run_check
  get '/grants/:id/verify_resources', to: 'grants#verify_resources', as: :verify_grant_resources
  get 'verify_all' => 'resources#verify_all'
  get 'verify_rar' => 'resources#verify_rar'
  get 'verify_dhc' => 'resources#verify_dhc'
  get 'stats' => 'grants#stats'

  # Defines the root path route ("/")
  root "grants#index"
end
