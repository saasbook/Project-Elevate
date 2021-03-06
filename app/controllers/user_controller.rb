class UserController < ApplicationController
  before_action :authenticate_user!
  protected

  def check_valid_date(month, day)
    begin
      Date.parse("#{day}-#{month}-#{Time.now.year.to_s}")
      return true
    rescue ArgumentError
      return false
    end
  end


  public
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
    if check_valid_date(params[:user][:month], params[:user][:day])
      flash[:coach] = "#{params[:user][:coach]}"
      flash[:day] = "#{params[:user][:day]}"
      flash[:month] = "#{params[:user][:month]}"
    else
      flash[:alert] = "Please select a valid date"
    end
    redirect_to booking_path
  end

  def multiple_booking
    @coaches = User.coaches
    @packages = PaymentPackage.where.not(name: "Single")
    render "multiple_booking"
  end

  def view_multiple_booking
    if check_valid_date(params[:user][:month], params[:user][:day])
      flash[:coach] = "#{params[:user][:coach]}"
      flash[:day] = "#{params[:user][:day]}"
      flash[:month] = "#{params[:user][:month]}"
      flash[:packages] = "#{params[:user][:packages]}"
    else
      flash[:alert] = "Please select a valid date"
    end
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
    @calendarsShow = @calendars.where(:UserId => [current_user.id, nil]).limit(5)
    @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count

    # For future developers: This part can be rewritten by inheriting interfaces so that it follows the open cloase principle. 
    if current_user.membership == 'Club Member'
      @user = current_user
      render "club_member_profile"
    elsif current_user.membership == 'Administrator'
      @users = User.all_users_except_admin
      render "administrator_profile"
    elsif current_user.membership == 'Coach'
      render "coach_profile"
    elsif current_user.membership == 'Manager'
      @users = User.manager_users_view
      render "manager_profile"
    end
  end

  def membership_statuses
    @name = current_user.name
    @membership = current_user.membership

    @users = User.all_users_except_admin
    render 'membership_status'    
  end

  def dashboard
    # @user = params[:u]
    # @id = @user.id
    # debug(@id)
    @user = @current_user
    @calendars = current_user.get_calendar
    @calendarsShow = @calendars.where(:UserId => [current_user.id, nil]).limit(5)
    @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count
    if @user.user_type == "Student"
      @usertype = "Student"
      @temp = Calendar.where(:UserId => @user.id)
      @total_classes_taught = Calendar.where(:UserId => @user.id).length
      @coaches = []
      if @temp != nil
        @temp.each do |i|
          if !(@coaches.include? i.OtherId) and User.find(i.OtherId).user_type == "Coach"
            @coaches << User.find(i.OtherId).name
          end
        end
      end
    elsif @user.user_type == "Coach"
      @usertype = "Coach"
      @temp = Calendar.where(:UserId => @user.id)
      @total_classes_taught = Calendar.where(:UserId => @user.id).length
      @students = []
      if @temp != nil
        @temp.each do |i|
          if !(@students.include? i.OtherId)
            @students << User.find(i.OtherId).name
          end
        end
      end
    else
      @usertype = "Administrator"
    end
    @member_since = @user.created_at.strftime("%B %d, %Y")
  end

end
