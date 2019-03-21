Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'member_profile' => 'home#member_profile', :as => 'member_profile'


  root to: "home#index"
end
