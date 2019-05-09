class ChargesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_current_user

    protected 
    def check_current_user
      if current_user.membership != "Club Member"
        redirect_to member_profile_path
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

      # Storing booked lesson in the database
      event_start_time = params[:event_start_time]
      event_end_time = params[:event_end_time]
      my_new_event_name = "Lesson: #{event_start_time} to #{event_end_time}"
      coach_new_event_name = "Coaching: #{event_start_time} to #{event_end_time}"
      my_new_event = Calendar.new(:name => my_new_event_name, :UserId => current_user.id, :OtherId => params[:coach_id].to_i, :start_time => params[:event_start], :end_time => params[:event_end], :typeEvent => "Coaching", :event_month => params[:month], :event_day => params[:day])
      coach_new_event = Calendar.new(:name => coach_new_event_name, :UserId => params[:coach_id].to_i, :OtherId => current_user.id, :start_time => params[:event_start], :end_time => params[:event_end], :typeEvent => "Coaching", :event_month => params[:month], :event_day => params[:day])
      my_new_event.save!
      coach_new_event.save!

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_charge_path
    
    end


    def checkout
      if (params[:user].nil? || params[:user][:temp_availability].nil?)
        flash[:alert] = "Please choose a time slot."
        redirect_to :controller => "user", :action => "booking" 
        return
      end

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


      @single_class_price = PaymentPackage.single_class_price
      @number_hours = 1
      @amount = @single_class_price
      # Only include this below if it is possible for amount to be 0
      # if @amount.to_i == 0
      #   flash[:error] = "Please select some credit"
      #   redirect_to booking_path
      # end
    end

    def show
    end




end
