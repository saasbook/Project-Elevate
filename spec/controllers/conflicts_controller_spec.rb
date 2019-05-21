require 'rails_helper'
require 'spec_helper'
require 'conflicts_controller'

def sign_in(user)
    post user_session_path \
      "user[email]"    => user.email,
      "user[password]" => user.password
end

RSpec.describe ConflictsController, type: :controller do
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
    end

    it "doesnt get to conflicts page if not admin" do
        sign_in(User.find_by_name("Roger Destroyer"))
        get "index"
        expect(subject).to_not render_template(:index)
        expect(response).to redirect_to root_path
    end

    it "renders no conflicts page if admin and no conflicts" do 
        sign_in(User.find_by_name("Matthew Sie"))
        get "index"
        expect(subject).to render_template(:no_conflicts)
    end

end
