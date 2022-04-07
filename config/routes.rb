Rails.application.routes.draw do
  devise_for :users,
             controllers: { confirmations: 'users/confirmations',
                            omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: [:index, :show, :destroy, :edit, :update] do
    member do
      patch :ban
    end
  end

  root 'static_pages#landing_page'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
