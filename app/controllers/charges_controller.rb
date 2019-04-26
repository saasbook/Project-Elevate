class ChargesController < ApplicationController

    before_action :check_current_user

    protected 
    def check_current_user
      if current_user.membership != "Club Member"
        redirect_to member_profile_path
      end
    end

    public 
    def new
      @possible_group_credits = ['0','1', '2','3', '4', '5', '6', '7', '8', '9', '10']
      @possible_assigned_credits = ['0','1', '2','3', '4', '5', '6', '7', '8', '9', '10']
      @possible_custom_credits = ['0','1', '2','3', '4', '5', '6', '7', '8', '9', '10']
    end
    
    def create
      # Amount in cents
      @amount_in_create = params[:amount]
      @amount = params[:amount].to_f*100
      @amount = @amount.to_i
    
      customer = Stripe::Customer.create({
        email: params[:stripeEmail],
        # email: current_user.email,
        source: params[:stripeToken],
      })
      
      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount
        # billing_details: {
        #   city: params[:stripeBillingAddressCity],
        #   country: params[:stripeBillingAddressCountry],
        #   postal_code: params[:stripeBillingAddressZip],
        #   state: params[:stripeBillingAddressState]
        # },
        description: 'Rails Stripe customer',
        currency: 'usd',
      })
      @custom_num_credit = params[:custom_num_credit].to_i + current_user.custom_num_credit.to_i
      @group_num_credit = params[:group_num_credit].to_i + current_user.group_num_credit.to_i
      @assigned_num_credit = params[:assigned_num_credit].to_i + current_user.assigned_num_credit.to_i
      current_user.custom_num_credit = @custom_num_credit.to_s
      current_user.group_num_credit = @group_num_credit.to_s
      current_user.assigned_num_credit = @assigned_num_credit.to_s
      current_user.save!
     
      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_charge_path
     
    
    end


    def checkout
        # Let's say assign_private is $50, custom_private is $100, and group is $25
        @assigned_private_cost = 50
        @custom_private_cost = 100
        @group_cost = 25
        @custom_num_credit = params[:user][:custom_num_credit].to_i
        @group_num_credit = params[:user][:group_num_credit].to_i
        @assigned_num_credit = params[:user][:assigned_num_credit].to_i
        @amount = @assigned_private_cost*@assigned_num_credit + @custom_private_cost*@custom_num_credit + @group_cost*@group_num_credit
        if @amount.to_i == 0
            flash[:error] = "Please select some credit"
            redirect_to new_charge_path
        end
    end

    def show
    end




end
