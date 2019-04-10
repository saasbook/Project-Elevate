class UserController < ApplicationController
  before_action :authenticate_user!

  def booking
    @coaches = User.coaches
    render "booking"
  end

  def availabilities
    @time_table = CoachAvailability.where(:coach_id => current_user.id)
    render "availabilities"
  end

  def add_availabilities
    start_time = "#{params[:user][:start_time]}:#{params[:user][:start_time_s]} #{params[:user][:start_time_ampm]}"
    end_time = "#{params[:user][:end_time]}:#{params[:user][:end_time_s]} #{params[:user][:end_time_ampm]}"
    st = Time.parse(start_time)
    et = Time.parse(end_time)

    if !CoachAvailability.valid_availibility(current_user.id, params[:user][:day], st, et)
      flash[:alert] = "Invalid Time"
      redirect_to availabilities_path
      return
    end

    avail = CoachAvailability.new(:day => params[:user][:day], :start_time => start_time, :end_time => end_time)
    
    avail.coach_id = current_user.id

    avail.save!
    redirect_to availabilities_path
  end

  def avail_params
    params.require(:user).permit(:coach_id, :player_id, :day, :start_time, :end_time)
  end

  def member_profile
    # For testing purposes below
    # if !(:current_user.blank?)
    #   @membership = :current_user.membership
    # end
    
    # For testing purposes above
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
      @users = User.manager_users_view
      render "manager_profile"
      # Add everything else needed here
    end

  end

end
