module RailsCalendar
  class Configuration
    attr_accessor :class_prefix
    attr_accessor :i18n_days
    attr_accessor :day_number_class
    attr_accessor :day_cell_class

    def initialize
      @class_prefix = 'calendar-'
      @i18n_days = 'date.abbr_day_names'
      @day_number_class = 'day-number'
      @day_cell_class = 'day-cell'
    end

    def get_class(name)
      name = "#{name}_class" unless name.to_s.end_with?('_class')
      "#{@class_prefix}#{send(name)}"
    end
  end
end
