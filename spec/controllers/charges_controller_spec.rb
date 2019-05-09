require 'rails_helper'
require 'spec_helper'
require 'charges_controller'

def sign_in(user)
    post user_session_path \
      "user[email]"    => user.email,
      "user[password]" => user.password
end

RSpec.describe ChargesController, type: :controller do
    before(:each) do
        users = [{:name => 'Joe Chen', :email => 'aaa@gmail.com', :password => '88888888', :membership => 'Club Member', :confirmed_at => Time.now.utc},
                 {:name => 'Roger Destroyer', :email => 'bbb@gmail.com', :password => '12345678', :membership => 'Coach', :confirmed_at => Time.now.utc},
                  {:name => 'Matthew Sie', :email => 'ccc@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator', :confirmed_at => Time.now.utc},
                  {:name => 'John Doe', :email => 'ddd@gmail.com', :password => '12345678', :membership => 'Manager', :confirmed_at => Time.now.utc}
         ]

        users.each do |user|
          User.create!(user)
        end

        PaymentPackage.create!({:name => 'Single', :num_classes => '1', :price => 1})
        PaymentPackage.create!({:name => 'Double', :num_classes => '2', :price => 5})
    end

    it "doesnt get to charges new page if not club member" do
        sign_in(User.find_by_name("Roger Destroyer"))
        get "new"
        expect(subject).to_not render_template(:new)
        expect(response).to redirect_to member_profile_path

    end

    it "renders checkout page" do
        sign_in(User.find_by_name("Joe Chen"))
        post "checkout", params: {:user => {:temp_availability => "2100-01-01 23:59:00 -0800,2100-01-01 00:00:00 -0800"},  :month => "12", :day => "31"}
        expect(subject).to render_template(:checkout)
    end

    it "doesnt render checkout if the booked time is before current time" do
        sign_in(User.find_by_name("Joe Chen"))
        post "checkout", params: {:user => {:temp_availability => "2000-01-01 00:00:00 -0800,2000-01-01 00:01:00 -0800"},  :month => "1", :day => "1"}
        expect(subject).to_not render_template(:checkout)
        expect(response).to redirect_to booking_path
    end

    it "doesnt render checkout but redirects if there is no availability" do
        sign_in(User.find_by_name("Joe Chen"))
        post "checkout", params: {:user => {:nothing => nil}}
        expect(subject).to_not render_template(:checkout)
        expect(response).to redirect_to booking_path

    end

    it "cant pay without without external stripe API and without valid param availabilities" do
        sign_in(User.find_by_name("Joe Chen"))
        post "create", params: {:user => {:custom_num_credit => "1", :group_num_credit => "0", :assigned_num_credit => "0"}}
        expect(response).to redirect_to new_charge_path
    end

    it "doesnt save lesson in Calendar after charging without external stripe API even with valid param availabilities" do
        sign_in(User.find_by_name("Joe Chen"))
        temp = "2100-01-01 01:00:00 -0800,2100-01-01 02:00:00 -0800"
        start_time = DateTime.parse(temp.split(',')[0])
        end_time = DateTime.parse(temp.split(',')[1])
        event_start = DateTime.new(DateTime.now.year.to_i, 12.to_i, 31.to_i, start_time.hour, start_time.minute, 0, "-07:00")
        event_end = DateTime.new(DateTime.now.year.to_i, 12.to_i, 31.to_i, end_time.hour, end_time.minute, 0, "-07:00")
        post "create", params: {:amount => 20, :event_start => event_start, :event_end => event_end, :event_start_time => event_start.strftime("%I:%M%p"), :event_end_time => event_end.strftime("%I:%M%p"), :month => "12", :day => "31"}
        expect(response).to redirect_to new_charge_path

    end

    it "doesnt save lesson in Calendar for multibooking after charging wihtout external stripe API even with valid param availabilities" do
        sign_in(User.find_by_name("Joe Chen"))
        temp = "2100-01-01 01:00:00 -0800,2100-01-01 02:00:00 -0800"
        start_time = DateTime.parse(temp.split(',')[0])
        end_time = DateTime.parse(temp.split(',')[1])
        coach = User.find_by_membership("Coach")
        event_start = DateTime.new(DateTime.now.year.to_i, 12.to_i, 31.to_i, start_time.hour, start_time.minute, 0, "-07:00")
        event_end = DateTime.new(DateTime.now.year.to_i, 12.to_i, 31.to_i, end_time.hour, end_time.minute, 0, "-07:00")
        post "create", params: {:amount => 20, :event_start => event_start, :event_end => event_end,
                                :event_start_time => event_start.strftime("%I:%M%p"), :event_end_time => event_end.strftime("%I:%M%p"),
                                :month_index => "12", :day_index => "1", :multiple_booking => "true", :coach_id => coach.id, :num_classes => "2"}
        expect(response).to redirect_to new_charge_path
    end

    it "doesnt go to checkout if there is no params user or temp availability" do
        sign_in(User.find_by_name("Joe Chen"))
        post "create", params: {:user => {:custom_num_credit => "1", :group_num_credit => "0", :assigned_num_credit => "0"}, :multiple_booking => "true"}
        expect(response).to redirect_to new_charge_path
    end

    it "renders checkout_multiple page" do
        sign_in(User.find_by_name("Joe Chen"))
        coach = User.find_by_membership("Coach")
        post "checkout_multiple", params: {:user => {:temp_availability => "2100-01-01 23:59:00 -0800,2100-01-01 00:00:00 -0800"},  :month => "11", :day => "1", :coach_id => coach.id, :packages => "2" }
        expect(subject).to render_template(:checkout_multiple)
    end

    it "doesnt render checkout_multiple if the booked time is before current time" do
        sign_in(User.find_by_name("Joe Chen"))
        coach = User.find_by_membership("Coach")
        post "checkout_multiple", params: {:user => {:temp_availability => "2000-01-01 00:00:00 -0800,2000-01-01 00:01:00 -0800"},  :month => "1", :day => "1", :coach_id => coach.id, :packages => "2" }
        expect(subject).to_not render_template(:checkout_multiple)
        expect(response).to redirect_to multiple_booking_path
    end

    it "doesnt render checkout_multiple but redirects if there is no availability" do
        sign_in(User.find_by_name("Joe Chen"))
        post "checkout_multiple", params: {:user => {:nothing => nil}, :packages => "5"}
        expect(subject).to_not render_template(:checkout_multiple)
        expect(response).to redirect_to multiple_booking_path
    end



end
