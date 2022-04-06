Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }

  resources :users, only: [:index, :show, :destroy]

  root 'static_pages#landing_page'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
