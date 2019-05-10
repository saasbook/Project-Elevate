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
      if params[:name] != nil
        @users = User.all
      else
        @users = User.all.where.not(:id => current_user.id)
      end
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

      # @admin = false
      # if current_user.membership == "Club Member"
      #     @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).where.not(:typeEvent => [nil, ""]).order(:start_time)
      # elsif current_user.membership == "Coach"
      #     @calendars = Calendar.all.where(:UserId => [current_user.id, nil]) #only booked classes currently
      # #add admin

      # else
      #   @calendars = Calendar.all
      #   @admin = true
      # end

  end

  # GET /calendars/1
  def show
    if coach_member
      if @calendar.UserId != current_user.id and @calendar.UserId != nil
          redirect_to  member_profile_path
      end
    end 
    if !@calendar.UserId.nil? and !@calendar.OtherId.nil?
      if current_user.membership == 'Club Member'
        @student = User.find(@calendar.UserId).name
        @instructor = User.find(@calendar.OtherId).name
      else
        @instructor = User.find(@calendar.UserId).name
        @student = User.find(@calendar.OtherId).name

      end
    end
  end
  # GET /calendars/new
  def new
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
  def create
      @calendar = Calendar.new(calendar_params)
      respond_to do |format|
        if @calendar.save
          format.html { redirect_to @calendar, notice: 'The event was successfully created.' }
          format.json { render :show, status: :created, location: @calendar }
        # else
        #   format.html { render :new }
        #   format.json { render json: @calendar.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to @calendar, notice: 'The event was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @calendar.errors, status: :unprocessable_entity }
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
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to root_path , notice: 'The event was successfully destroyed.' }
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




