class AddMembershipToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :membership, :string
  end
end
