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
    end
end
