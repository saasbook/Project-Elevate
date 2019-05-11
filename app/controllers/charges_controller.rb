class ChargesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_current_user
    before_action :check_time_slot, only: [:checkout, :checkout_multiple]
  
    protected 
    def check_current_user
      if current_user.membership != "Club Member"
        redirect_to member_profile_path
      end
    end

    def check_time_slot
      if (params[:user].nil? || params[:user][:temp_availability].nil?)
        flash[:alert] = "Please choose a time slot."
        # use params[:packages] to check if it's sinlge booking or multibooking
        if (params[:packages].blank?)
          redirect_to :controller => "user", :action => "booking" 
        else
          redirect_to :controller => "user", :action => "multiple_booking" 
        end
        return
      end
    end

    def create_stripe_customer(email, stripe_token)
      customer = Stripe::Customer.create({
        email: email,
        source: stripe_token,
      })
      return customer

    end

    def create_stripe_charges(amount, customer)
      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: amount,
        description: 'Rails Stripe customer',
        currency: 'usd',
      })
      return charge
    end

    def create_invoice(amount, customer)
      Stripe::InvoiceItem.create({
          amount: amount,
          currency: 'usd',
          customer: customer.id,
          description: 'Lesson fee',
      })
      invoice = Stripe::Invoice.create({
        customer: customer.id,
        billing: 'send_invoice',
        days_until_due: 30,
      })

      return invoice

    end

    # Checking if the event time is before the current time
    def check_time_past(event_start, multiple_booking, year)
      if year > DateTime.now.year.to_i
        return false
      end
      if event_start.past?
        flash[:alert] = "Please choose a future time slot."
        if multiple_booking
          redirect_to :controller => "user", :action => "multiple_booking"
        else
          redirect_to :controller => "user", :action => "booking"
        end
        return true
      end
      return false
    end

    # Check if increasing seven days update month based on current year If so, return correct day and month index. 
    # If not, just return day_index + 7 and original month_index
    def update_day_month(day_index, month_index, year_index)
       # incrementing by 7 days and updating month and day and year
       day_index += 7
       if (day_index > 31) and (month_index == 12)
        next_year = year_index + 1
        updated_day_index = day_index - Time.days_in_month(1, year = next_year)
        return [updated_day_index, 1, next_year]
       end
       if (day_index > Time.days_in_month(month_index, year = year_index))
        updated_day_index = day_index - Time.days_in_month(month_index, year = year_index)
        updated_month_index = month_index + 1
        return [updated_day_index, updated_month_index, year_index]
       else
        return [day_index, month_index, year_index]
       end
    end

    public 
    def new
    end
    
    def create

      event_arr = []
      event_start_time, event_end_time = params[:event_start_time], params[:event_end_time]
      my_new_event_name, coach_new_event_name = "Lesson: #{event_start_time} to #{event_end_time}", "Coaching: #{event_start_time} to #{event_end_time}"
      # Storing booked lessons in the database for multiple booking
      if params[:multiple_booking] == "true"
        num_classes = params[:num_classes].to_i
        month_index, day_index = params[:month_index].to_i, params[:day_index].to_i
        start_time_hour, end_time_hour = params[:start_time_hour].to_i, params[:end_time_hour].to_i
        start_time_minute, end_time_minute = params[:start_time_minute].to_i, params[:end_time_minute].to_i
        year_index = DateTime.now.year.to_i
        for i in 1..num_classes do
          event_start = Time.zone.local(year_index, month_index, day_index, start_time_hour, start_time_minute, 0)
          event_end = Time.zone.local(year_index, month_index, day_index, end_time_hour, end_time_minute, 0)
  
          temp_type_event, conflict = "Coaching", "No Conflict"
          if !(Booking.check_time_slot(event_start, event_end, params[:coach_id].to_i, [month_index, day_index, year_index]))
            conflict = "Conflict"
          end
          
          my_new_event = Calendar.new(:name => my_new_event_name, :UserId => current_user.id, :OtherId => params[:coach_id].to_i, :start_time => event_start, :end_time => event_end, :typeEvent => temp_type_event, :event_month => month_index.to_s, :event_day => day_index.to_s, :conflict => conflict)
          coach_new_event = Calendar.new(:name => coach_new_event_name, :UserId => params[:coach_id].to_i, :OtherId => current_user.id, :start_time => event_start, :end_time => event_end, :typeEvent => temp_type_event, :event_month => month_index.to_s, :event_day => day_index.to_s,  :conflict => conflict)
          event_arr << my_new_event
          event_arr << coach_new_event
  
          # incrementing by 7 days and updating month and day
          day_index, month_index, year_index = update_day_month(day_index, month_index, year_index)
        end
      else
         # Storing booked lesson in the database for single booking
        my_new_event = Calendar.new(:name => my_new_event_name, :UserId => current_user.id, :OtherId => params[:coach_id].to_i, :start_time => params[:event_start], :end_time => params[:event_end], :typeEvent => "Coaching", :event_month => params[:month], :event_day => params[:day])
        coach_new_event = Calendar.new(:name => coach_new_event_name, :UserId => params[:coach_id].to_i, :OtherId => current_user.id, :start_time => params[:event_start], :end_time => params[:event_end], :typeEvent => "Coaching", :event_month => params[:month], :event_day => params[:day])
        event_arr << my_new_event
        event_arr << coach_new_event
      end
      # Amount in cents
      @amount_in_create = params[:amount]
      @amount = params[:amount].to_f*100
      @amount = @amount.to_i
      
      customer = create_stripe_customer(params[:stripeEmail], params[:stripeToken])
      charge = create_stripe_charges(@amount, customer)
      invoice = create_invoice(@amount, customer)
      #Actually sending customer invoices through email
      invoice.send_invoice
      #Actually save in database
      event_arr.each do |event| 
        event.save!

      end

      
      

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_charge_path
    
    end


    def checkout

      # Parsing time
      start_time = DateTime.parse(params[:user][:temp_availability].split(',')[0])
      end_time = DateTime.parse(params[:user][:temp_availability].split(',')[1])
      @event_start = Time.zone.local(DateTime.now.year.to_i, params[:month].to_i, params[:day].to_i, start_time.hour, start_time.minute, 0)
      @event_end = Time.zone.local(DateTime.now.year.to_i, params[:month].to_i, params[:day].to_i, end_time.hour, end_time.minute, 0)
      @month = params[:month]
      @day = params[:day]
      @coach = params[:coach_id]
      
      #Checking if it's invalid time (namely if the booked time is before current time). If it is, then flash error
      if check_time_past(@event_start, false, DateTime.now.year.to_i)
        return
      end

      @number_hours = 1
      @amount = PaymentPackage.single_class_price
  
    end

    # Checkout controller for multiple booking
    def checkout_multiple
      conflicting_lessons, lessons = "", ""
      @num_classes = params[:packages].to_i
      start_time, end_time = DateTime.parse(params[:user][:temp_availability].split(',')[0]), DateTime.parse(params[:user][:temp_availability].split(',')[1])

      day_index, month_index = params[:day].to_i, params[:month].to_i 
      @day_index, @month_index = day_index, month_index
      year_index = DateTime.now.year.to_i
      for i in 1..@num_classes do
        event_start = Time.zone.local(year_index, month_index, day_index, start_time.hour, start_time.minute, 0)
        event_end = Time.zone.local(year_index, month_index, day_index, end_time.hour, end_time.minute, 0)
        if i != @num_classes or @num_classes == 1
          lessons += Date::MONTHNAMES[month_index] + " " + day_index.to_s + ", "
        else
          lessons += "and " + Date::MONTHNAMES[month_index] + " " + day_index.to_s
        end
        # Checking if it's invalid time (namely if the booked time is before current time). If it is, then flash error 
        if check_time_past(event_start, true, year_index)
          return
        end
        # Checking if there are conflicted lessons and add the dates into a string
        if !(Booking.check_time_slot(event_start, event_end, params[:coach_id].to_i, [month_index, day_index, year_index]))
          conflicting_lessons += Date::MONTHNAMES[month_index] + " " + day_index.to_s + ", "
        end
        # incrementing by 7 days and updating month and day
        day_index, month_index, year_index = update_day_month(day_index, month_index, year_index)
      end
      if (conflicting_lessons != "")
        flash.now[:alert] = conflicting_lessons.prepend("(Please contact Admin for more information) Conflicting lessons on ")[0...-2]
      end
      @start_time_hour, @start_time_minute = start_time.hour, start_time.minute
      @end_time_hour, @end_time_minute = end_time.hour, end_time.minute
      @coach_id, @multiple_booking = params[:coach_id], "true"
      @amount, @lessons = PaymentPackage.payment_package_price_by_num_class(@num_classes), lessons
      @event_start, @event_end = event_start, event_end
      @og_amount = @num_classes * PaymentPackage.single_class_price
      @savings = @og_amount - @amount
      @savings_percent = (100 * @savings / @og_amount.to_f).round(2) 
    end

    def show
    end




end
