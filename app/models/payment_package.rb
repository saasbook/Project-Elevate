class PaymentPackage < ApplicationRecord
    def self.single_class_price
        return PaymentPackage.where(:name => 'Single').first.price
    end

    def self.payment_package_price_by_num_class(num_class)
        return PaymentPackage.where(:num_classes => num_class).where.not(:name => 'Single').first.price
    end

    def name_and_num_classes
        return "#{self.name} (#{self.num_classes})"
    end

    def self.gen_stats(num_classes, amount)
      og_amount = num_classes * self.single_class_price
      savings = og_amount - amount
      savings_percent = (100 * savings / og_amount.to_f).round(2)

      return og_amount, savings, savings_percent
    end
end
