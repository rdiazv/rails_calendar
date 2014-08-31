module RailsCalendar
  class Configuration
    attr_accessor :class_prefix
    attr_accessor :i18n_days
    attr_accessor :day_number_class

    def initialize
      @class_prefix = 'calendar-'
      @i18n_days = 'date.abbr_day_names'
      @day_number_class = 'day-number'
    end
  end
end
