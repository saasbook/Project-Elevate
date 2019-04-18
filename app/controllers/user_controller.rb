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
    redirect_to '/user/profile'
  end

  def booking
    @coaches = User.coaches
    render "booking"
  end

  def calendar
    if current_user.membership == "Club Member"
        @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
    elsif current_user.membership == "Coach"
        @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time) #only booked classes currently
    else
        @calendars = Calendar.all
    #add admin
    end
  end

  def view_booking
    flash[:coach] = "#{params[:user][:coach]}"
    redirect_to booking_path
  end

  def confirmation_booking
    chosen_time_slot = params[:user]
    if (chosen_time_slot.nil?)
      redirect_to booking_path
    else
      chosen_time_slot = params[:user][:temp_availability]

      available_day = chosen_time_slot.split('/')[1]

      start_time_hour = chosen_time_slot.split('/')[2].split(' ')[0].split(':')[0].to_i
      start_time_minute = chosen_time_slot.split('/')[2].split(' ')[0].split(':')[1].to_i
      start_time_ampm = chosen_time_slot.split('/')[2].split(' ')[1]
      if ((start_time_ampm == "PM") & !(start_time_hour == 12))
        start_time_hour = start_time_hour + 12
      end

      end_time_hour = chosen_time_slot.split('/')[3].split(' ')[0].split(':')[0].to_i
      end_time_minute = chosen_time_slot.split('/')[3].split(' ')[0].split(':')[1].to_i
      end_time_ampm = chosen_time_slot.split('/')[3].split(' ')[1]

      if ((end_time_ampm == "PM") & !(end_time_hour == 12))
        end_time_hour = end_time_hour + 12
      end

      list_of_months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      month = list_of_months.index(params[:user][:month]) + 1
      day = params[:user][:day].to_i
      my_id = current_user.id
      coach_id = chosen_time_slot.split('/')[0].to_i
      start_date_time = DateTime.new(DateTime.now.year.to_i, month, day, start_time_hour, start_time_minute)
      end_date_time = DateTime.new(DateTime.now.year.to_i, month, day, end_time_hour, end_time_minute)


      my_new_event = Calendar.new(:name => "Coaching", :UserId => my_id, :OtherId => coach_id, :start_time => start_date_time, :end_time => end_date_time, :typeEvent => "Coaching")
      coach_new_event = Calendar.new(:name => "Coaching", :UserId => coach_id, :OtherId => my_id, :start_time => start_date_time, :end_time => end_date_time, :typeEvent => "Coaching")
      my_new_event.save!
      coach_new_event.save!
      render "confirmation_booking"
    end

    # avail = Calendar.new(:name =>, :start_time =>, :end_time =>, :typeEvent => "Coaching")
    #
    # avail.coach_id = current_user.id
    #
    # avail.save!

  end

  def calendar
    if current_user.membership == "Club Member"
        @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
    elsif current_user.membership == "Coach"
        @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time) #only booked classes currently
    else
        @calendars = Calendar.all
    #add admin
    end
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

  def delete_availabilities
    CoachAvailability.delete(params[:id])
    redirect_to availabilities_path
    return
  end

  def member_profile
    # For testing purposes below
    # if !(:current_user.blank?)
    #   @membership = :current_user.membership
    # end

    # For testing purposes above
    @name = current_user.name
    @membership = current_user.membership
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

end
