json.extract! calendar, :id, :name, :UserId, :OtherId, :start_time, :end_time, :typeEvent, :event_month, :event_day, :created_at, :updated_at
json.url calendar_url(calendar, format: :json)
