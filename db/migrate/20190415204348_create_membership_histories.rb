class CreateMembershipHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_histories do |t|
      t.integer :user_changed_id, null:false
      t.integer :changed_by_id, null:false
      t.string  :old_membership, null:false
      t.string  :new_membership, null:false
      t.timestamps
    end
  end
end
