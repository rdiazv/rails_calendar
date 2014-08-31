module RailsCalendar
  class Configuration
    attr_accessor :i18n_days

    def initialize
      @i18n_days = 'date.abbr_day_names'
    end
  end
end
