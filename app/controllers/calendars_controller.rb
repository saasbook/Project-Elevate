class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]
  # GET /calendars
  # GET /calendars.json
  def index
    
          if current_user.membership == "Club Member"
              @calendars =Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
          elsif current_user.membership == "Coach"
              @calendars = Calendar.all.where(:UserId => [current_user.id, nil]) #only booked classes currently
          #add admin
          else 
            @calendars = Calendar.all
          end
  
  end
  
  def all 
    if current_user.membership == "Administrator"
      @users = User.all
    else
      render error_404_path
    end
  end
  
  def viewall 
    setAdminCalendars
  end
  
  def eventList
    
    setAdminCalendars
  end 
  
  def setAdminCalendars
    if current_user.membership == "Administrator"
      @calendars = Calendar.all.where(:UserId => [params[:UserId], nil])
      @user = User.all.where(:id => params[:UserId]).first
    else
      render error_404_path
    end
  end

  # # GET /calendars/1
  # # GET /calendars/1.json
  # def show
  # end

  # # GET /calendars/new
  # def new
  #   @calendar = Calendar.new
  # end

  # # GET /calendars/1/edit
  # def edit
  # end

  # # POST /calendars
  # # POST /calendars.json
  # def create
  #   @calendar = Calendar.new(calendar_params)

  #   respond_to do |format|
  #     if @calendar.save
  #       format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
  #       format.json { render :show, status: :created, location: @calendar }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @calendar.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /calendars/1
  # # PATCH/PUT /calendars/1.json
  # def update
  #   respond_to do |format|
  #     if @calendar.update(calendar_params)
  #       format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @calendar }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @calendar.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /calendars/1
  # # DELETE /calendars/1.json
  # def destroy
  #   @calendar.destroy
  #   respond_to do |format|
  #     format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:name, :UserId, :OtherId, :start_time, :end_time, :typeEvent)
    end
end
