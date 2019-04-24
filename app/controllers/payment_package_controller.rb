class PaymentPackageController < ApplicationController
    before_action :require_admin_priv
    before_action :authenticate_user!

    def require_admin_priv
        if current_user.membership != 'Administrator'
            redirect_to root_path
        end
    end

    def index
        @packages = PaymentPackage.all
        # render 'index'
    end

    def create
        params[:payment_package].each do |k, v|
            if v.empty?
                flash[:alert] = 'Missing fields or non-unqiue name'
                redirect_to payment_package_path && return
            end
        end
        PaymentPackage.create!(params[:payment_package].permit(:name, :num_classes, :price))
        redirect_to payment_package_path
    end
end
