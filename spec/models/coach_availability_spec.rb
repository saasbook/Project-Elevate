require 'rails_helper'

RSpec.describe CoachAvailability, type: :model do
  describe 'availibity functionality' do
    before(:each) do
      User.create!({:id => 100, :name => 'Roger Destroyer', :email => 'bbb@gmail.com', :password => '12345678', :membership => 'Coach'})
      avails = [
        {:id => 100, :coach_id => 100, :day => "Sunday", :start_time => '6am', :end_time => '9am'},
        {:id => 101, :coach_id => 100, :day => "Sunday", :start_time => '12pm', :end_time => '3pm'},
        {:id => 102, :coach_id => 100, :day => "Sunday", :start_time => '6pm', :end_time => '9pm'},
      ]
      
      avails.each do |avail|
        CoachAvailability.create!(avail)
      end
    end

    it 'can add a valid time' do
      expect(CoachAvailability.valid_availibility(100, "Sunday", Time.parse("9am"), Time.parse("12pm"))).to be(true)
    end

    it 'cannot add an invalid time' do
      expect(CoachAvailability.valid_availibility(100, "Sunday", Time.parse("6am"), Time.parse("8am"))).to be(false)
      expect(CoachAvailability.valid_availibility(100, "Sunday", Time.parse("6am"), Time.parse("9am"))).to be(false)
      expect(CoachAvailability.valid_availibility(100, "Sunday", Time.parse("6am"), Time.parse("7am"))).to be(false)
      expect(CoachAvailability.valid_availibility(100, "Sunday", Time.parse("6am"), Time.parse("2pm"))).to be(false)
      expect(CoachAvailability.valid_availibility(100, "Sunday", Time.parse("7am"), Time.parse("2pm"))).to be(false)
    end

    it 'can return a coaches availability' do
      sample = CoachAvailability.this_week(100)["Sunday"].pluck(:id)
      expect(sample).to include(100,101, 102)
    end
  end
end
