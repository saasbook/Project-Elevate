Given /the following payment_packages exist/ do |pp_table|
    pp_table.hashes.each do |pp|
      PaymentPackage.create pp
    end
  end