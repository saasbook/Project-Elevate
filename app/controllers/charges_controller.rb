class ChargesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_current_user
    before_action :check_time_slot_single, only: [:checkout]
    before_action :check_time_slot_multiple, only: [:checkout_multiple]

    protected 
    def check_current_user
      if current_user.membership != "Club Member"
        redirect_to member_profile_path
      end
    end

    def check_time_slot_multiple
      if (params[:user].nil? || params[:user][:temp_availability].nil?)
        flash[:alert] = "Please choose a time slot."
        redirect_to :controller => "user", :action => "multiple_booking" 
        return
      end
    end

    def check_time_slot_single
      if (params[:user].nil? || params[:user][:temp_availability].nil?)
        flash[:alert] = "Please choose a time slot."
        redirect_to :controller => "user", :action => "booking" 
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

    public 
    def new
    end
    
    def create
      # Amount in cents
      @amount_in_create = params[:amount]
      @amount = params[:amount].to_f*100
      @amount = @amount.to_i
      
      customer = create_stripe_customer(params[:stripeEmail], params[:stripeToken])
      charge = create_stripe_charges(@amount, customer)
      invoice = create_invoice(@amount, customer)
      #Actually sending customer invoices through email
      invoice.send_invoice

      event_start_time = params[:event_start_time]
      event_end_time = params[:event_end_time]
      my_new_event_name = "Lesson: #{event_start_time} to #{event_end_time}"
      coach_new_event_name = "Coaching: #{event_start_time} to #{event_end_time}"
      # Storing booked lessons in the database for multiple booking
      if params[:multiple_booking] == "true"
        num_classes = params[:num_classes]
        month_index = params[:month_index].to_i
        day_index = params[:day_index].to_i
        start_time_hour = params[:start_time_hour].to_i
        end_time_hour = params[:end_time_hour].to_i
        start_time_minute = params[:start_time_minute].to_i
        end_time_minute = params[:end_time_minute].to_i
    
        for i in 1..num_classes.to_i do
          event_start = DateTime.new(DateTime.now.year.to_i, month_index, day_index, start_time_hour, start_time_minute, 0, "-07:00")
          event_end = DateTime.new(DateTime.now.year.to_i, month_index, day_index, end_time_hour, end_time_minute, 0, "-07:00")
  
          temp_type_event = "Coaching"
          conflict = "No Conflict"
          if !(Booking.check_time_slot(event_start, event_end, params[:coach_id].to_i, [month_index, day_index]))
            # temp_type_event = ""
            conflict = "Conflict"
          end
  
          my_new_event = Calendar.new(:name => my_new_event_name, :UserId => current_user.id, :OtherId => params[:coach_id].to_i, :start_time => event_start, :end_time => event_end, :typeEvent => temp_type_event, :event_month => month_index.to_s, :event_day => day_index.to_s, :conflict => conflict)
          coach_new_event = Calendar.new(:name => coach_new_event_name, :UserId => params[:coach_id].to_i, :OtherId => current_user.id, :start_time => event_start, :end_time => event_end, :typeEvent => temp_type_event, :event_month => month_index.to_s, :event_day => day_index.to_s,  :conflict => conflict)
          my_new_event.save!
          coach_new_event.save!
  
  
          day_index += 7
          if (day_index > Time.days_in_month(month_index, year = DateTime.now.year.to_i))
            day_index = day_index - Time.days_in_month(month_index, year = DateTime.now.year.to_i)
            month_index += 1
          end
        end

      else
         # Storing booked lesson in the database for single booking
        my_new_event = Calendar.new(:name => my_new_event_name, :UserId => current_user.id, :OtherId => params[:coach_id].to_i, :start_time => params[:event_start], :end_time => params[:event_end], :typeEvent => "Coaching", :event_month => params[:month], :event_day => params[:day])
        coach_new_event = Calendar.new(:name => coach_new_event_name, :UserId => params[:coach_id].to_i, :OtherId => current_user.id, :start_time => params[:event_start], :end_time => params[:event_end], :typeEvent => "Coaching", :event_month => params[:month], :event_day => params[:day])
        my_new_event.save!
        coach_new_event.save!
      end
      
      

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_charge_path
    
    end


    def checkout

      # Parsing time
      start_time = DateTime.parse(params[:user][:temp_availability].split(',')[0])
      end_time = DateTime.parse(params[:user][:temp_availability].split(',')[1])
      @event_start = DateTime.new(DateTime.now.year.to_i, params[:month].to_i, params[:day].to_i, start_time.hour, start_time.minute, 0, "-07:00")
      @event_end = DateTime.new(DateTime.now.year.to_i, params[:month].to_i, params[:day].to_i, end_time.hour, end_time.minute, 0, "-07:00")
      @month = params[:month]
      @day = params[:day]
      @coach = params[:coach_id]
      
      #Checking if it's invalid time (namely if the booked time is before current time). If it is, then flash error
      if @event_start.past?
        flash[:alert] = "Please choose a future time slot."
        redirect_to :controller => "user", :action => "booking"
        return
      end

      @number_hours = 1
      @amount = PaymentPackage.single_class_price
  
    end

    # Checkout controller for multiple booking
    def checkout_multiple
      conflicting_lessons = ""
      lessons = ""
      num_classes = params[:packages]

      start_time = DateTime.parse(params[:user][:temp_availability].split(',')[0])
      end_time = DateTime.parse(params[:user][:temp_availability].split(',')[1])

      day_index = params[:day].to_i
      month_index = params[:month].to_i
      @day_index = day_index
      @month_index = month_index
      for i in 1..num_classes.to_i do
        event_start = DateTime.new(DateTime.now.year.to_i, month_index, day_index, start_time.hour, start_time.minute, 0, "-07:00")
        event_end = DateTime.new(DateTime.now.year.to_i, month_index, day_index, end_time.hour, end_time.minute, 0, "-07:00")
        lessons += Date::MONTHNAMES[month_index] + " " + day_index.to_s + ", "
        if !(Booking.check_time_slot(event_start, event_end, params[:coach_id].to_i, [month_index, day_index]))
          conflicting_lessons += Date::MONTHNAMES[month_index] + " " + day_index.to_s + ", "
        end
        day_index += 7
        if (day_index > Time.days_in_month(month_index, year = DateTime.now.year.to_i))
          day_index = day_index - Time.days_in_month(month_index, year = DateTime.now.year.to_i)
          month_index += 1
        end
      end
      if (conflicting_lessons != "")
        flash.now[:alert] = conflicting_lessons.prepend("Conflicting lessons on ")[0...-2]
      end
    
      @start_time_hour = start_time.hour
      @start_time_minute = start_time.minute
      @end_time_hour = end_time.hour
      @end_time_minute = end_time.minute
      @coach_id = params[:coach_id]
      @multiple_booking = "true"
      @num_classes = params[:packages]
      @amount = PaymentPackage.payment_package_price_by_num_class(num_classes.to_i)
      @event_start = event_start
      @event_end = event_end
      @lessons = lessons
      

    end
    
    def show
    end




end
