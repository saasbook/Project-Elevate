require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'get all coaches' do
    before(:each) do
      users = [{:name => 'Joe Chen', :email => 'aaa@gmail.com', :password => '88888888', :membership => 'Club Member'},
    	  {:name => 'Roger Destroyer', :email => 'bbb@gmail.com', :password => '12345678', :membership => 'Coach'},
				{:name => 'Matthew Sie', :email => 'ccc@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator'},
				{:name => 'John Doe', :email => 'ddd@gmail.com', :password => '12345678', :membership => 'Manager'}
  	 ]

      users.each do |user|
        User.create!(user)
      end
    end

    it 'gets only coaches' do
      expect(User.coaches).to include(User.find(2))
    end

    it 'does not get non-coaches' do
      expect(User.coaches).not_to include(User.find(1))
      expect(User.coaches).not_to include(User.find(4))
    end

    it 'gets everyone except admin' do
      @users = User.all_users_except_admin
      expect(@users).not_to include(User.find(3))
    end

    it 'get everyone except admin and managers' do
      @users = User.manager_users_view
      expect(@users).to include(User.find(1))
      expect(@users).to include(User.find(2))
      expect(@users).not_to include(User.find(3))
      expect(@users).not_to include(User.find(4))
    end

    it 'updates membership in admin view' do
      @updated_membership_list = User.admin_update_membership_to(User.find(1))
      expect(@updated_membership_list).not_to include(User.find(1).membership)

    end

    it 'updates membership in manager view' do
      @updated_membership_list = User.manager_update_membership_to(User.find(1))
      expect(@updated_membership_list).not_to include(User.find(1).membership)

    end

  end
end
