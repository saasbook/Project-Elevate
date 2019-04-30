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
        users = [{:name => 'Joe Chen', :email => 'aaa@gmail.com', :password => '88888888', :membership => 'Club Member'},
                 {:name => 'Roger Destroyer', :email => 'bbb@gmail.com', :password => '12345678', :membership => 'Coach'},
                  {:name => 'Matthew Sie', :email => 'ccc@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator'},
                  {:name => 'John Doe', :email => 'ddd@gmail.com', :password => '12345678', :membership => 'Manager'}
         ]
  
        users.each do |user|
          User.create!(user)
        end

        PaymentPackage.create!({:name => 'Single', :num_classes => '1', :price => 1})
    end
    it "signs in to new page to select credits if club member" do 
        sign_in(User.find_by_name("Joe Chen"))
        get "new"
        expect(subject).to render_template(:new)
    end

    it "doesnt get to charges new page if not club member" do
        sign_in(User.find_by_name("Roger Destroyer"))
        get "new"
        expect(subject).to_not render_template(:new)
        expect(response).to redirect_to member_profile_path

    end

    it "renders checkout page" do 
        sign_in(User.find_by_name("Joe Chen"))
        post "checkout", params: {:user => {:custom_num_credit => "100", :group_num_credit => "25", :assigned_num_credit => "50"}}
        expect(subject).to render_template(:checkout)
    end

    it "doesnt render checkout but redirects if no credit is bought" do
        sign_in(User.find_by_name("Joe Chen"))
        post "checkout", params: {:user => {:custom_num_credit => "0", :group_num_credit => "0", :assigned_num_credit => "0"}}
        expect(subject).to_not render_template(:checkout)
        expect(response).to redirect_to new_charge_path

    end 

    it "cant pay without using external stripe API" do
        sign_in(User.find_by_name("Joe Chen"))
        post "create", params: {:user => {:custom_num_credit => "1", :group_num_credit => "0", :assigned_num_credit => "0"}}
        expect(response).to redirect_to new_charge_path
    end

    

    
end
