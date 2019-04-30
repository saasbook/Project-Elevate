class PaymentPackage < ApplicationRecord
    def self.single_class_price
        return PaymentPackage.where(:name => 'Single').first.price
    end
end
