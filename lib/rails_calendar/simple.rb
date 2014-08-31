require 'action_view'

module RailsCalendar
  class Simple
    include ActionView::Helpers
    include ActionView::Context

    attr_reader :config

    def initialize
      @config = RailsCalendar.configuration
    end

    private

    def header
      content_tag :thead do
        content_tag :tr do
          I18n.t(config.i18n_days).each do |day|
            concat content_tag(:th, day.titleize)
          end
        end
      end
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
