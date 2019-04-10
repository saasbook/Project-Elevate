require 'rails_helper'

RSpec.describe CoachAvailability, type: :model do
  describe 'availibity functionality' do
    before(:each) do
      User.create!({:name => 'Roger Destroyer', :email => 'bbb@gmail.com', :password => '12345678', :membership => 'Coach'})
      avails = [
        {:coach_id => 1, :day => "Sunday", :start_time => '6am', :end_time => '9am'},
        {:coach_id => 1, :day => "Sunday", :start_time => '12pm', :end_time => '3pm'},
        {:coach_id => 1, :day => "Sunday", :start_time => '6pm', :end_time => '9pm'},
      ]
      
      avails.each do |avail|
        CoachAvailability.create!(avail)
      end
    end

    it 'can add a valid time' do
      expect(CoachAvailability.valid_availibility(1, "Sunday", "9am", "12pm")).to be(true)
    end

    it 'cannot add an invalid time' do
      expect(CoachAvailability.valid_availibility(1, "Sunday", "6am", "7am")).to be(false)
      expect(CoachAvailability.valid_availibility(1, "Sunday", "6am", "8am")).to be(false)
      expect(CoachAvailability.valid_availibility(1, "Sunday", "6am", "9am")).to be(false)
      expect(CoachAvailability.valid_availibility(1, "Sunday", "6am", "2pm")).to be(false)
      expect(CoachAvailability.valid_availibility(1, "Sunday", "7am", "2pm")).to be(false)
    end
  end
end
