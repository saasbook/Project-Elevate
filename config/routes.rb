Rails.application.routes.draw do
  # get 'user/member_profile'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'user/member_profile' => 'user#member_profile', :as => 'member_profile'


  root to: "home#index"

end
