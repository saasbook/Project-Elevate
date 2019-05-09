class PaymentPackage < ApplicationRecord
    def self.single_class_price
        return PaymentPackage.where(:name => 'Single').first.price
    end

    def self.payment_package_price_by_num_class(num_class)
        return PaymentPackage.where(:num_classes => num_class).first.price
    end
end
