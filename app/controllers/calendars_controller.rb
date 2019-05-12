class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  # GET /calendars
  def index

    @admin = false
      if not coach_member
        @admin = true
      end
    @calendars =Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
  end
  
  def all 
    if not coach_member
        @users = User.all.where.not(:id => current_user.id)
      # end
    else
      redirect_to member_profile_path
    end
  end
  
  def viewall 
    setAdminCalendars
  end
  
  def eventList
    
    setAdminCalendars
  end 
  
  def setAdminCalendars
    if not coach_member
      @calendars = Calendar.all.where(:UserId => [params[:UserId], nil]).order(:start_time)
      @user = User.all.where(:id => params[:UserId]).first
    else
      redirect_to  member_profile_path
    end


  end

  # GET /calendars/1
  def redirecter
    if coach_member
      if @calendar.UserId != current_user.id and @calendar.UserId != nil
          redirect_to  member_profile_path
      end
    end 
  end 
  
  def show
    redirecter
    if !@calendar.UserId.nil? and !@calendar.OtherId.nil? and @calendar.UserId != 0 and @calendar.OtherId != 0
      @user1 =  User.find(@calendar.UserId)
      @user2 = User.find(@calendar.OtherId).name
      if @user1.membership == "Club Member"
        @student = @user1.name
        @instructor =  @user2
      else
        @instructor = @user1.name
        @student = @user2
      end
    end
  end
  # GET /calendars/new
  def new
     @email = "z"
    @calendar = Calendar.new
    if coach_member
    
      redirect_to  member_profile_path
    end
  end

  # # GET /calendars/1/edit
  # def edit
  # end

  # POST /calendars
  # POST /calendars.json
  def redirecterError
    flash[:error] = true
      if !User.exists?(:email => params['calendar']['email1']) 
        flash[:email1] = "Email 1 does not exist."
      end
      if !User.exists?(:email => params['calendar']['email2']) 
        flash[:email2] = "Email 2 does not exist."
      end
      redirect_to request.referrer
  end  
  
  def createSetNames
    @calendarTemp = User.where(:email => params['calendar']['email1']).first
    @calendar2Temp = User.where(:email => params['calendar']['email2']).first
    @calendar.UserId = @calendarTemp.id
    @calendar.OtherId = @calendar2Temp.id
  end 
  
  def paramsEmailChecker
    if params['calendar']['email1'] != "" and (!User.exists?(:email =>  params['calendar']['email1']) or  !User.exists?(:email =>  params['calendar']['email2']))
      return true
    end 
    return false
  end 

  def create
    if paramsEmailChecker
      redirecterError
    else 
      @calendar = Calendar.new(calendar_params)
      if params['calendar']['email1'] != ""
        createSetNames
        if @calendar.UserId != nil
          @calendar2 = Calendar.new(calendar_params)
          @calendar2.OtherId = @calendar.UserId
          @calendar2.UserId = @calendar.OtherId
          @calendar2.save
        end 
      end
      respond_to do |format|
          if @calendar.save
            format.html { redirect_to @calendar, notice: 'The event was successfully created.' }
            format.json { render :show, status: :created, location: @calendar }
          end
        end 
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    if paramsEmailChecker
      redirecterError
    else    
      respond_to do |format|
        if params['calendar']['email1'] != ""
          params['calendar']['UserId'] = User.where(:email => params['calendar']['email1']).first.id
          params['calendar']['OtherId'] = User.where(:email => params['calendar']['email2']).first.id
        end
        if @calendar.UserId != nil
          @calendar2 = Calendar.where(:UserId => @calendar.OtherId, :OtherId => @calendar.UserId, :details => @calendar.details, :name => @calendar.name, :start_time => @calendar.start_time, :end_time => @calendar.end_time)
        end 
        if @calendar.update(calendar_params)
          temp = params['calendar']['UserId']
          params['calendar']['UserId'] = params['calendar']['OtherId']
          params['calendar']['OtherId'] = temp
          if@calendar.UserId != nil 
             @calendar2.update(calendar_params)
          end
          format.html { redirect_to @calendar, notice: 'The event was successfully updated.' }
          format.json { render :show, status: :ok, location: @calendar }
        # else
        #   format.html { render :edit }
        #   format.json { render json: @calendar.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  
  def coach_member
    x = current_user.membership == "Club Member" or current_user.membership == "Coach"
    return x
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    if @calendar.UserId != nil
      @calendar2 = Calendar.where(:UserId => @calendar.OtherId, :OtherId => @calendar.UserId, :details => @calendar.details, :name => @calendar.name, :start_time => @calendar.start_time, :end_time => @calendar.end_time).first
      if @calendar2 != nil 
        @calendar2.destroy
      end
    end
    @calendar.destroy
    
    respond_to do |format|
      format.html { redirect_to member_profile_path , notice: 'The event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

    def calendar_params
      params.require(:calendar).permit(:name, :UserId, :OtherId, :start_time, :end_time, :details)
    end
end




