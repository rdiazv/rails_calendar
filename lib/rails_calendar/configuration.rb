module RailsCalendar
  class Configuration
    attr_accessor :class_prefix
    attr_accessor :i18n_days
    attr_accessor :day_number_class
    attr_accessor :day_cell_class
    attr_accessor :today_class
    attr_accessor :start_of_week

    def initialize

    def to_h
      {
        class_prefix: @class_prefix,
        i18n_days: @i18n_days,
        day_number_class: @day_number_class,
        day_cell_class: @day_cell_class,
        today_class: @today_class,
        start_of_week: @start_of_week
      }
    end
      @class_prefix = 'calendar-'
      @i18n_days = 'date.abbr_day_names'
      @day_number_class = 'day-number'
      @day_cell_class = 'day-cell'
      @today_class = 'today'
      @start_of_week = :sunday
    end

    def get_class(name)
      name = "#{name}_class" unless name.to_s.end_with?('_class')
      "#{@class_prefix}#{send(name)}"
    end
  end
end
