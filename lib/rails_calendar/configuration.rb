module RailsCalendar
  class Configuration
    attr_accessor :class_prefix
    attr_accessor :i18n_days
    attr_accessor :table_class
    attr_accessor :day_number_class
    attr_accessor :day_cell_class
    attr_accessor :day_name_class
    attr_accessor :day_contents_class
    attr_accessor :today_class
    attr_accessor :another_month_class
    attr_accessor :start_of_week

    def initialize
      reset!
    end

    def to_h
      {
        class_prefix: @class_prefix,
        i18n_days: @i18n_days,
        table_class: @table_class,
        day_number_class: @day_number_class,
        day_cell_class: @day_cell_class,
        day_name_class: @day_name_class,
        day_contents_class: @day_contents_class,
        today_class: @today_class,
        another_month_class: @another_month_class,
        start_of_week: @start_of_week
      }
    end

    def reset!
      @class_prefix = 'calendar-'
      @i18n_days = 'date.abbr_day_names'
      @table_class = 'table'
      @day_number_class = 'day-number'
      @day_cell_class = 'day-cell'
      @day_name_class = 'day-name'
      @day_contents_class = 'day-contents'
      @today_class = 'today'
      @another_month_class = 'another-month'
      @start_of_week = :sunday
    end

    def get_class(name)
      name = "#{name}_class" unless name.to_s.end_with?('_class')
      "#{@class_prefix}#{send(name)}"
    end
  end
end
