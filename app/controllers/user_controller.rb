class UserController < ApplicationController
  before_action :authenticate_user!

  def update_other
    @other = User.find(params[:id])
    old_membership = @other.membership
    if !params[:user].blank?
      @other.update_attributes(params.require(:user).permit(:membership))
      MembershipHistory.create(:user_changed_id => @other.id, :changed_by_id => current_user.id,
        :old_membership => old_membership, :new_membership => @other.membership)
    end
    redirect_to membership_status_path
  end



  #==================================
  #=         START   BOOKING        =
  #==================================
  def booking
    @coaches = User.coaches
    render "booking"
  end

  def view_booking
    flash[:coach] = "#{params[:user][:coach]}"
    flash[:day] = "#{params[:user][:day]}"
    flash[:month] = "#{params[:user][:month]}"
    redirect_to booking_path
  end

  def multiple_booking
    @coaches = User.coaches
    @packages = PaymentPackage.where("num_classes > '1'")
    render "multiple_booking"
  end

  def view_multiple_booking
    flash[:coach] = "#{params[:user][:coach]}"
    flash[:day] = "#{params[:user][:day]}"
    flash[:month] = "#{params[:user][:month]}"
    flash[:packages] = "#{params[:user][:packages]}"
    redirect_to multiple_booking_path
  end

  #==================================
  #=         END BOOKING            =
  #==================================

  def calendar
     @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
  end

  def availabilities
    @time_table = CoachAvailability.sorted_avail_for_coach(current_user.id)
    render "availabilities"
  end

  def add_availabilities
    start_time = "#{params[:user][:start_time]}:#{params[:user][:start_time_s]} #{params[:user][:start_time_ampm]} PST"
    end_time = "#{params[:user][:end_time]}:#{params[:user][:end_time_s]} #{params[:user][:end_time_ampm]} PST"
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

  def delete_availabilities
    CoachAvailability.delete(params[:id])
    redirect_to availabilities_path
    return
  end

  def member_profile
    @name = current_user.name
    @membership = current_user.membership
    @calendars = current_user.get_calendar
    @calendarsShow = @calendars.limit(5)
    @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count

    if current_user.membership == 'Club Member'
      @user = current_user
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

  def membership_statuses
    @name = current_user.name
    @membership = current_user.membership

    @users = User.all_users_except_admin
    render 'membership_status'    
  end

end
