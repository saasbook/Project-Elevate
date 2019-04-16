Rails.application.routes.draw do
  get 'error/error'
  resources :charges
  # get 'user/member_profile'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'user/profile' => 'user#member_profile', :as => 'member_profile'
 
  # Route when an admin or manager submits form to update a user's membership status
  post 'user/profile/update_other' => 'user#update_other', :as => 'update_other'

  # Route for admin to view change log of all membership status changes
  get 'user/profile/membership_history' => 'membership_history#membership_history', :as => 'membership_history'
  
  get 'user/booking' => 'user#booking', :as => 'booking'
  post 'charges/checkout' => 'charges#checkout', :as => 'checkout'

  # availabilities routes
  get 'users/profile/availabilities' => 'user#availabilities', :as =>'availabilities'
  post 'users/profile/availabilities' => 'user#add_availabilities', :as =>'add_availabilities'
  delete 'users/profile/availabilities/:id' => 'user#delete_availabilities', :as =>'delete_availabilities'

  root to: "home#index"
  # This needs to be at the end
  match '*path' => 'error#error_404', via: :all

end
