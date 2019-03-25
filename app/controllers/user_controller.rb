class UserController < ApplicationController

  def member_profile

    if current_user.membership.blank?
      
    end
        
    if current_user.membership == 'Club Member'
        redirect_to club_member_profile_path
        # Add everything else needed here
    elsif current_user.membership == 'Administrator'
        redirect_to administrator_profile_path
        # Add everything else needed here
    elsif current_user.membership == 'Coach'
        redirect_to coach_profile_path
        # Add everything else needed here
    elsif current_user.membership == 'Manager'
        redirect_to manager_profile_path
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
