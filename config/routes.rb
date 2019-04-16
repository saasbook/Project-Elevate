Rails.application.routes.draw do
  resources :calendars
  get 'error/error'
  # get 'user/member_profile'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'user/profile' => 'user#member_profile', :as => 'member_profile'

  post 'user/profile/update_other' => 'user#update_other', :as => 'update_other'

  get 'user/booking' => 'user#booking', :as => 'booking'
  post 'user/confirmation_booking' => 'user#confirmation_booking', :as => 'confirmation_booking'
  post 'user/profile/view_booking' => 'user#view_booking', :as =>'view_booking'

  get 'user/calendar' => 'user#calendar', :as => 'user_calendar'

  # availabilities routes
  get 'users/profile/availabilities' => 'user#availabilities', :as =>'availabilities'
  post 'users/profile/availabilities' => 'user#add_availabilities', :as =>'add_availabilities'
  delete 'users/profile/availabilities/:id' => 'user#delete_availabilities', :as =>'delete_availabilities'



  root to: "home#index"
  # This needs to be at the end
  match '*path' => 'error#error_404', via: :all

end
