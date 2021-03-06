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
        rescue => ex
            flash[:alert] = 'Missing fields or non-unqiue name'
            redirect_to payment_package_path and return
        end

        if params[:payment_package][:name] == "Single"
            flash[:alert] = "Can not have two Single packages"
        elsif not PaymentPackage.find_by_num_classes(params[:payment_package][:num_classes]).blank?
            flash[:alert] = "Can not create two packages with the same number of classes"
        else
            PaymentPackage.create!(params[:payment_package].permit(:name, :num_classes, :price))
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
