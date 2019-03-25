class UserController < ApplicationController

  def member_profile
    @membership = current_user.membership
    if current_user.membership == 'Club Member'
      render "club_member_profile"
      # Add everything else needed here
    elsif current_user.membership == 'Administrator'
      @users = User.all_users_except_admin


      
      render "administrator_profile"
      # Add everything else needed here
    elsif current_user.membership == 'Coach'
      render "coach_profile"
      # Add everything else needed here
    elsif current_user.membership == 'Manager'
      render "manager_profile"
      # Add everything else needed here
    end

  end

  def coach_profile
      @membership = 'Coach'
  end

  def club_member_profile
    @membership = 'Club Member'
  end

  def manager_profile
    @membership = 'Manager'
  end

  def administrator_profile
    @membership = 'Administrator'
  end
end
