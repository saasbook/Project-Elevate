Rails.application.routes.draw do
  get 'error/error'
  # get 'user/member_profile'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'user/profile' => 'user#member_profile', :as => 'member_profile'
 
  get 'user/booking' => 'user#booking', :as => 'booking'

  root to: "home#index"
  # This needs to be at the end
  match '*path' => 'error#error_404', via: :all

end
