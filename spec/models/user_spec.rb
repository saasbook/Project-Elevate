# require 'rails_helper'

# RSpec.describe User, type: :model do
#   describe 'get all coaches' do
#     before(:each) do
#       users = [{:name => 'Joe Chen', :email => 'chenjoe@gmail.com', :password => '88888888', :membership => 'Club Member'},
#     	  {:name => 'Roger Destroyer', :email => 'rogerahh@gmail.com', :password => '12345678', :membership => 'Coach'},
# 				{:name => 'Matthew Sie', :email => 'matthew.sie@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator'},
# 				{:name => 'John Doe', :email => 'johndoe@gmail.com', :password => '12345678', :membership => 'Manager'}
#   	 ]

#       users.each do |user|
#         User.create!(user)
#       end
#     end

#     it 'gets all coaches' do
#       expect(User.coaches).to include(User.find(2))
#       expect(User.coaches).not_to include(User.find(1))
#       expect(User.coaches).not_to include(User.find(4))
#     end
#   end
# end
