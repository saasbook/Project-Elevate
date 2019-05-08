Rails.application.routes.draw do
  resources :calendars

  get 'error/error_404' => 'error#error_404', :as => 'error_404'
  resources :charges
  # get 'user/member_profile'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'user/profile' => 'user#member_profile', :as => 'member_profile'

  # Route when an admin or manager submits form to update a user's membership status
  post 'user/profile/update_other' => 'user#update_other', :as => 'update_other'

  # Route for admin to view change log of all membership status changes
  get 'user/profile/membership_history' => 'membership_history#membership_history', :as => 'membership_history'

  # booking routes
  get 'user/booking' => 'user#booking', :as => 'booking'
  get 'user/multiple_booking' => 'user#multiple_booking', :as => 'multiple_booking'
  post 'user/profile/view_booking' => 'user#view_booking', :as =>'view_booking'
  post 'user/multiple_confirmation_booking' => 'user#multiple_confirmation_booking', :as => 'multiple_confirmation_booking'
  post 'user/profile/view_multiple_booking' => 'user#view_multiple_booking', :as =>'view_multiple_booking'



  post 'charges/checkout' => 'charges#checkout', :as => 'checkout'

  get 'user/payments' => 'payment_package#index', :as => 'payment_package'
  post 'user/payments/add' => 'payment_package#create', :as => 'add_payment_package'
  get 'user/payments/:id/edit' => 'payment_package#edit', :as => 'edit_payment_package'
  post 'user/payments/:id/edit' => 'payment_package#update', :as => 'update_payment_package'
  delete 'user/payments/:id' => 'payment_package#delete', :as => 'delete_payment_package'

  get 'user/calendar' => 'user#calendar', :as => 'user_calendar'

  get '/' => 'home#index', :as => 'root'

  get '/pass' => 'home#pass', :as => 'pass'



  # availabilities routes
  get 'users/profile/availabilities' => 'user#availabilities', :as =>'availabilities'
  post 'users/profile/availabilities' => 'user#add_availabilities', :as =>'add_availabilities'
  delete 'users/profile/availabilities/:id' => 'user#delete_availabilities', :as =>'delete_availabilities'


  root to: "home#index"
  # This needs to be at the end
  match '*path' => 'error#error_404', via: :all

end
