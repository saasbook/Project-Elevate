class PaymentPackage < ApplicationRecord
    # Return the seeded Single price
    def self.single_class_price
        return PaymentPackage.where(:name => 'Single').first.price
    end
    # Return the payment package that fits the number of classes that is not "Single". There should have no same number of classes in the table
    def self.payment_package_price_by_num_class(num_class)
        return PaymentPackage.where(:num_classes => num_class).where.not(:name => 'Single').first.price
    end

    def name_and_num_classes
        return "#{self.name} (#{self.num_classes})"
    end
end
