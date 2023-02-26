class DayStreak < ApplicationRecord
    belongs_to :user

    def self.configure_expiration
        todays_date = Date.today
        date_time = DateTime.new(todays_date.year, todays_date.month, todays_date.day)
        date_time = date_time.next_day(2)
        date_time
    end
end
