class AddConflictToCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :conflict, :string
  end
end
