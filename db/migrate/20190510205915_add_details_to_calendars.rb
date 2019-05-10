class AddDetailsToCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :calendars, :details, :string
  end
end
