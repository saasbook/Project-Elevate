class CreatePaymentPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_packages do |t|
      t.string :name, null: false, :unique => true
      t.integer :num_classes, null: false
      t.integer :price, null: false
      t.timestamps
    end
  end
end
