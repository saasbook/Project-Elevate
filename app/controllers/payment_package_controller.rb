class PaymentPackageController < ApplicationController
    before_action :authenticate_user!    
    before_action :require_admin_priv

    def require_admin_priv
        if current_user.membership != 'Administrator'
            redirect_to root_path
        end
    end

    def index
        @packages = PaymentPackage.all
    end

    def create
        begin
            params[:payment_package].require([:name, :num_classes, :price])
            if params[:payment_package][:name] == "Single"
                flash[:alert] = "Can not have two Single packages"
                redirect_to payment_package_path and return
            else
                PaymentPackage.create!(params[:payment_package].permit(:name, :num_classes, :price))
            end
        rescue => ex
            flash[:alert] = 'Missing fields or non-unqiue name'
        end
        
        redirect_to payment_package_path
    end

    def edit
        @package = PaymentPackage.find(params[:id])
        @name = @package.name
    end

    def update
        par = params[:payment_package].reject{|_, v| v.blank?}
        PaymentPackage.find(params[:id]).update_attributes!(par.permit(:name, :num_classes, :price))
        redirect_to payment_package_path
    end

    def delete
        if params[:id] != 1
            PaymentPackage.destroy(params[:id])
        end
        redirect_to payment_package_path
    end
end
