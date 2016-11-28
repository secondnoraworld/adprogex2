Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get 'auth/:provider/callback' => 'sessions#create'
  get 'signout' => 'sessions#destroy'

  get 'twitter' => 'twitter#index', :as => 'twitter'
  get 'twitter/:request' => 'twitter#show'

  get 'github' => 'github#index', :as => 'github'

end
