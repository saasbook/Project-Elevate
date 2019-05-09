require 'rails_helper'
require 'spec_helper'
require 'charges_controller'

RSpec.describe UserController, type: :controller do
    before(:each) do
        users = [
            {:id => 200, :name => 'Joe Chen', :email => 'aaa@gmail.com', :password => '88888888', :membership => 'Club Member', :confirmed_at => Time.now.utc},
            {:id => 201, :name => 'Roger Destroyer', :email => 'bbb@gmail.com', :password => '12345678', :membership => 'Coach', :confirmed_at => Time.now.utc},
            {:id => 202, :name => 'Matthew Sie', :email => 'ccc@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator', :confirmed_at => Time.now.utc},
            {:id => 203, :name => 'John Doe', :email => 'ddd@gmail.com', :password => '12345678', :membership => 'Manager', :confirmed_at => Time.now.utc}
         ]

        users.each do |user|
          User.create!(user)
        end
    end

    it "renders booking/multiple booking/calendar" do
        sign_in(User.find_by_name("Joe Chen"))
        get "booking"
        expect(subject).to render_template(:booking)

        get "multiple_booking"
        expect(subject).to render_template(:multiple_booking)

        get "calendar"
        expect(subject).to render_template(:calendar)
    end

    it "renders calendar for admin separately" do
        sign_in(User.find_by_name("Matthew Sie"))
        get "calendar"
        expect(subject).to render_template(:calendar)
    end

    it "renders availabilities" do
        sign_in(User.find_by_name("Roger Destroyer"))
        get "availabilities"
        expect(subject).to render_template(:availabilities)
    end

    it "renders member profile" do
        sign_in(User.find_by_name("Joe Chen"))
        get "member_profile"
        expect(subject).to render_template(:club_member_profile)
    end

    it "renders coach profile" do
        sign_in(User.find_by_name("Roger Destroyer"))
        get "member_profile"
        expect(subject).to render_template(:coach_profile)
    end

    it "renders administrator profile" do
        sign_in(User.find_by_name("Matthew Sie"))
        get "member_profile"
        expect(subject).to render_template(:administrator_profile)
    end

    it "renders manager profile" do
      sign_in(User.find_by_name("John Doe"))
      get "member_profile"
      expect(subject).to render_template(:manager_profile)
    end

    it "redirects me to single booking path after choosing params" do
        sign_in(User.find_by_name("Joe Chen"))
        post "view_booking", params: {:user => {:coach => "201", :month => "1", :day => "1"}}
        expect(response).to redirect_to booking_path
    end

    it "redirects me to multi booking path after choosing params" do
        sign_in(User.find_by_name("Joe Chen"))
        post "view_multiple_booking", params: {:user => {:coach => "201", :month => "1", :day => "1", :packages => "5"}}
        expect(response).to redirect_to multiple_booking_path
    end

    it "redirects me after adding a valid availability" do
        sign_in(User.find_by_name("Roger Destroyer"))
        post "add_availabilities", params: {:user => {:day => "Monday", :start_time => "9", :start_time_s => "00", :start_time_ampm => "AM", :end_time => "10", :end_time_s => "00", :end_time_ampm => "AM"}}
        expect(response).to redirect_to availabilities_path
    end

    it "redirects me after adding an invalid availability" do
        sign_in(User.find_by_name("Roger Destroyer"))
        post "add_availabilities", params: {:user => {:day => "Monday", :start_time => "9", :start_time_s => "00", :start_time_ampm => "AM", :end_time => "8", :end_time_s => "00", :end_time_ampm => "AM"}}
        expect(response).to redirect_to availabilities_path
    end

    it "redirects me after deleting an availability" do
        sign_in(User.find_by_name("Roger Destroyer"))
        delete "delete_availabilities", params: {:id => 200}
        expect(response).to redirect_to availabilities_path
    end

    it "redirects properly for an admin updating someone else's membership" do
        sign_in(User.find_by_name("Matthew Sie"))
        post "update_other", params: {:id => 200}
        expect(response).to redirect_to membership_status_path
    end
end
