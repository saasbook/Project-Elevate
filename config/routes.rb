Rails.application.routes.draw do
  # get 'user/member_profile'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'user/member_profile' => 'user#member_profile', :as => 'member_profile'
  get 'user/coach_profile' => 'user#coach_profile', :as => 'coach_profile'
  get 'user/club_member_profile' => 'user#club_member_profile', :as => 'club_member_profile'
  get 'user/manager_profile' => 'user#manager_profile', :as => 'manager_profile'
  get 'user/administrator_profile'=> 'user#administrator_profile', :as => 'administrator_profile'


  root to: "home#index"

end
