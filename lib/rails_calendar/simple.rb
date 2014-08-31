require 'action_view'
require 'active_support/all'

module RailsCalendar
  class Simple
    include ActionView::Helpers
    include ActionView::Context

    attr_reader :config
    attr_accessor :calendar_day

    def initialize(calendar_day = Date.today)
      @config = RailsCalendar.configuration
      @calendar_day = calendar_day
    end

    def to_s
      table
    end

    private

    def table
      content_tag :table do
        header + body
      end
    end

    def header
      content_tag :thead do
        content_tag :tr do
          I18n.t(config.i18n_days).each do |day|
            concat content_tag(:th, day.titleize)
          end
        end
      end
    end

    def body
      rows = weeks.map do |week|
        content_tag :tr do
          week.each do |day|
            concat day_cell(day)
          end
        end
      end

      content_tag :tbody, rows.join('').html_safe
    end

    def weeks
      first = calendar_day.beginning_of_month.beginning_of_week
      last = calendar_day.end_of_month.end_of_week
      (first..last).to_a.in_groups_of(7)
    end

    def day_cell(date)
      content_tag(:td, class: day_cell_classes(date)) do
        concat content_tag(:span, date.day, class: config.get_class(:day_number))
      end
    end

    def day_cell_classes(date)
      classes = []
      classes << config.get_class(:day_cell)
      classes << config.get_class(:today) if date == Date.today
      classes.empty? ? nil : classes.join(' ')
    end
  end
end
