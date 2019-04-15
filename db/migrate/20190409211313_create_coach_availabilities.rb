class CreateCoachAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :coach_availabilities do |t|
      t.integer :coach_id, null: false
      t.integer :player_id, null: true
      t.string :day, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
