class ChargesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_current_user
    before_action :check_time_slot, only: [:checkout, :checkout_multiple]

    protected
    # Check if current user is a club member. If not, redirect them to their profile page
    def check_current_user
      if current_user.membership != "Club Member"
        flash[:alert] = "Only Club Member can book lessons"
        redirect_to member_profile_path
      end
    end

    # Check if any time slot is selected both for single booking and multibooking
    def check_time_slot
      if (params[:user].nil? || params[:user][:temp_availability].nil?)
        flash[:alert] = "Please choose a time slot."
        if params[:action] == "checkout_multiple"
          redirect_to :controller => "user", :action => "multiple_booking"
        else
          redirect_to :controller => "user", :action => "booking"
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

    # Checking if the selected event time is before the current time
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

    # Returns a list of [day, month, year] after increasing the day by 7(a week).
    def update_day_month(day_index, month_index, year_index)
       # incrementing by 7 days and updating month and day and year
       day_index += 7
       # Checking if it is going to a new year
       if (day_index > 31) and (month_index == 12)
        next_year = year_index + 1
        updated_day_index = day_index - Time.days_in_month(1, year = next_year)
        return [updated_day_index, 1, next_year]
       end
       # If it's not going to a new year, check if it is going to a new month and update accordingly
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
      # Storing booked lessons in the database for multiple booking
      if params[:multiple_booking] == "true"
        event_arr = create_multi(params)
      else
        # Storing booked lesson in the database for single booking
        event_arr = create_single(params)
      end
      # Amount in cents
      @amount_in_create = params[:amount]
      @amount = (params[:amount].to_f*100).to_i

      customer = create_stripe_customer(params[:stripeEmail], params[:stripeToken])
      charge = create_stripe_charges(@amount, customer)
      #Actually sending customer invoices through email
      create_invoice(@amount, customer).send_invoice
      #Actually save in database
      event_arr.each do |event|
        event.save!
      end

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_charge_path
    end

    def create_single(params)
      event_arr = []
      event_arr << Calendar.create_event([params[:event_start], params[:event_end], params[:month], params[:day]], [current_user.id, params[:coach_id].to_i, params[:coach_id].to_i], ["Coaching Lesson", "Coaching"], false)
      event_arr << Calendar.create_event([params[:event_start], params[:event_end], params[:month], params[:day]], [params[:coach_id].to_i, current_user.id, params[:coach_id].to_i], ["Coaching Lesson", "Coaching"], false)
      return event_arr
    end

    def create_multi(params)
      event_arr = []
      month_index, day_index, year_index = params[:month_index].to_i, params[:day_index].to_i, DateTime.now.year.to_i

      for i in 1..params[:num_classes].to_i do
        event_start = Time.zone.local(year_index, month_index, day_index, params[:start_time_hour].to_i, params[:start_time_minute].to_i, 0)
        event_end = Time.zone.local(year_index, month_index, day_index, params[:end_time_hour].to_i, params[:end_time_minute].to_i, 0)
        conflict = "No Conflict"
        if !(Booking.check_time_slot(event_start, event_end, params[:coach_id].to_i, [month_index, day_index, year_index]))
          conflict = "Conflict"
          event_arr << Calendar.create_event([event_start, event_end, month_index, day_index, year_index], [current_user.id, params[:coach_id].to_i, params[:coach_id].to_i], ["Coaching Lesson", "Coaching", "Conflict"], true)
          event_arr << Calendar.create_event([event_start, event_end, month_index, day_index, year_index], [params[:coach_id].to_i, current_user.id, params[:coach_id].to_i], ["Coaching Lesson", "Coaching", "No Conflict"], true)
        else
          event_arr << Calendar.create_event([event_start, event_end, month_index, day_index, year_index], [current_user.id, params[:coach_id].to_i, params[:coach_id].to_i], ["Coaching Lesson", "Coaching", conflict], true)
          event_arr << Calendar.create_event([event_start, event_end, month_index, day_index, year_index], [params[:coach_id].to_i, current_user.id, params[:coach_id].to_i], ["Coaching Lesson", "Coaching", conflict], true)
        end
        # incrementing by 7 days and updating month and day
        day_index, month_index, year_index = update_day_month(day_index, month_index, year_index)
      end

      return event_arr
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
      @num_classes = params[:packages].to_i
      start_time, end_time = DateTime.parse(params[:user][:temp_availability].split(',')[0]), DateTime.parse(params[:user][:temp_availability].split(',')[1])

      day_info = [params[:day].to_i, params[:month].to_i, DateTime.now.year.to_i]
      @day_index, @month_index, @year_index = day_info
      @event_start = Time.zone.local(day_info[2], day_info[1], day_info[0], start_time.hour, start_time.minute, 0)
      @event_end = Time.zone.local(day_info[2], day_info[1], day_info[0], end_time.hour, end_time.minute, 0)

      # Checking if it's invalid time (namely if the booked time is before current time). If it is, then flash error
      if check_time_past(Time.zone.local(day_info[2], day_info[1], day_info[0], start_time.hour, start_time.minute, 0), true, day_info[2])
        return
      end

      lessons, conflicting_lessons = get_lessons(@num_classes, day_info, start_time, end_time)

      @start_time_hour, @start_time_minute, @end_time_hour, @end_time_minute = start_time.hour, start_time.minute, end_time.hour, end_time.minute
      @coach_id, @multiple_booking = params[:coach_id], "true"
      @amount, @lessons = PaymentPackage.payment_package_price_by_num_class(@num_classes), lessons
      @og_amount, @savings, @savings_percent = PaymentPackage.gen_stats(@num_classes, @amount)
    end

    def show
    end

    def append_lesson(i, num_classes, month_index, day_index)
      if i != num_classes or num_classes == 1
        return  Date::MONTHNAMES[month_index] + " " + day_index.to_s + ", "
      else
        return "and " + Date::MONTHNAMES[month_index] + " " + day_index.to_s
      end
    end

    def get_lessons(num_classes, day_info, start_time, end_time)
      conflicting_lessons, lessons = "", ""
      day_index, month_index, year_index = day_info

      for i in 1..num_classes do
        event_start = Time.zone.local(year_index, month_index, day_index, start_time.hour, start_time.minute, 0)
        event_end = Time.zone.local(year_index, month_index, day_index, end_time.hour, end_time.minute, 0)
        lessons += append_lesson(i, num_classes, month_index, day_index)

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

      return lessons, conflicting_lessons
    end
end
