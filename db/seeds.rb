# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


users = [{:name => 'Joe Chen', :email => 'chenjoe@gmail.com', :password => '88888888', :membership => 'Club Member', :confirmed_at => Time.now.utc},
    	  {:name => 'Roger Destroyer', :email => 'rogerahh@gmail.com', :password => '12345678', :membership => 'Coach', :confirmed_at => Time.now.utc},
				{:name => 'Matthew Sie', :email => 'matthew.sie@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator', :confirmed_at => Time.now.utc},
				{:name => 'John Doe', :email => 'johndoe@gmail.com', :password => '12345678', :membership => 'Manager', :confirmed_at => Time.now.utc},
				{:name => 'Jason Yang', :email => 'jason@gmail.com', :password => '123456', :membership => 'Club Member', :confirmed_at => Time.now.utc}
  	 ]

users.each do |user|
  User.create!(user)
end

calendars = [{:name => "Train with the Roger Destroyer", :UserId => 1, :OtherId => 2,  :typeEvent => "Coaching", :start_time => "2020-04-05 10:00:00", :end_time => "2020-04-05 12:00:00"},
            {:name => "Coach Joe Chen", :UserId => 2, :OtherId => 1,  :typeEvent => "Coaching", :start_time => "2020-04-05 10:00:00", :end_time => "2020-04-05 12:00:00"},
            {:name => "Club Event", :UserId => nil, :OtherId => nil,  :typeEvent => "Event", :start_time => "2019-04-11 10:00:00", :end_time => "2019-04-11 12:00:00"},
            {:name => "Club Event", :UserId => nil, :OtherId => nil,  :typeEvent => "Event", :start_time => "2019-04-05 10:00:00", :end_time => "2019-04-05 12:00:00"},
            {:name => "Club Event", :UserId => nil, :OtherId => nil,  :typeEvent => "Event", :start_time => "2020-04-13 10:00:00", :end_time => "2020-04-13 12:00:00"},
            {:name => "Club Event", :UserId => nil, :OtherId => nil,  :typeEvent => "Event", :start_time => "2019-04-14 10:00:00", :end_time => "2019-04-14 12:00:00"},
            {:name => "Club Event", :UserId => nil, :OtherId => nil,  :typeEvent => "Event", :start_time => "2019-04-21 10:00:00", :end_time => "2019-04-21 12:00:00"},
            {:name => "Play with Joe Chen", :UserId => 5, :OtherId => 1,  :typeEvent => "Play", :start_time => "2019-04-23 10:00:00", :end_time => "2019-04-23 12:00:00"},
            {:name => "Play with Jason Yang", :UserId => 1, :OtherId => 5,  :typeEvent => "Play", :start_time => "2019-04-23 10:00:00", :end_time => "2019-04-23 12:00:00"},
            {:name => "Coach Jason Yang", :UserId =>2, :OtherId => 5, :typeEvent => "Coaching", :start_time => "2019-04-14 10:00:00", :end_time => "2019-04-14 12:00:00"}, 
            {:name => "Train with Roger Destroyer", :UserId =>5, :OtherId => 2, :typeEvent => "Coaching", :start_time => "2019-04-14 10:00:00", :end_time => "2019-04-14 12:00:00"}]


calendars.each do |calendar|
  Calendar.create!(calendar)
end

payment_packages = [{:name => "Bronze", :num_classes => 5, :price => 100}, 
                    {:name => "Silver", :num_classes => 10, :price => 175}, 
                    {:name => "Gold", :num_classes => 20, :price => 300}]

payment_packages.each do |pp|
  PaymentPackage.create!(pp)
end
