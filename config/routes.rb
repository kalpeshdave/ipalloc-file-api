Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :devices, param: :ip_address, only: [:show], :constraints => { :ip_address => /[0-9.]+/ }
  
  resources :addresses, except: [:index, :new, :create, :show, :edit, :update, :destroy] do
    post :assign, on: :collection
  end
end
