# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [{:nickname => 'Joe Chen', :email => 'chenjoe@gmail.com', :password => '88888888', :membership => 'Club Member'},
    	  {:nickname => 'Roger Destroyer', :email => 'rogerahh@gmail.com', :password => '12345678', :membership => 'Coach'},
				{:nickname => 'Matthew Sie', :email => 'matthew.sie@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator'},
				{:nickname => 'John Doe', :email => 'johndoe@gmail.com', :password => '12345678', :membership => 'Manager'}
  	 ]

users.each do |user|
  User.create!(user)
end
