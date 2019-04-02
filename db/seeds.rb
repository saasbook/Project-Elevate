# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


users = [{:full_name => 'Joe Chen', :email => 'chenjoe@gmail.com', :password => '88888888', :membership => 'Player'},
    	  {:full_name => 'Roger Destroyer', :email => 'rogerahh@gmail.com', :password => '12345678', :membership => 'Coach'},
				{:full_name => 'Matthew Sie', :email => 'matthew.sie@berkeley.edu', :password => 'dabaka22', :membership => 'Administrator'},
				{:full_name => 'John Doe', :email => 'johndoe@gmail.com', :password => '12345678', :membership => 'Coach'},
        {:full_name => 'Table Tennis Club', :email => 'testing@testing.edu', :password => '123456', :membership => 'Administrator'}
  	 ]

users.each do |user|
  User.create!(user)
end

# <% if (user.my_admin.eql?(current_user.full_name)) %>
  # <%= user.full_name %><br />
  # <%= f.label "User membership" %><br />
  # <%= f.text_field :membership, autofocus: true, autocomplete: "user_membership" %><br />
# <% end %>
