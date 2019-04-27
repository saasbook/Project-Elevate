# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    when /^Login page$/i
      new_user_session_path
    
    when /^User Membership Change Log page$/i
      membership_history_path
    
    when /^(.*)'s My Profile Page$/i
      user = User.find_by_name($1)
      member_profile_path :current_user => user 

    when /^(.*)'s Availabilities Page$/i
      user = User.find_by_name($1)
      availabilities_path :current_user => user 

    when /^Buy Credits page$/i
      new_charge_path

    when /^Payment Packages Page$/i
      payment_package_path

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
