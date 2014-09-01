module RailsCalendar
  module Helpers
    def rails_calendar(date = Date.today, &block)
      RailsCalendar::Simple.new(date, self, &block)
    end
  end
end
