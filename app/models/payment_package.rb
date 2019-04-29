class PaymentPackage < ApplicationRecord

    def self.single_class_price
        return PaymentPackage.find(1).price
    end
end
