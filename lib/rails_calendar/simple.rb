require 'action_view'

module RailsCalendar
  class Simple
    include ActionView::Helpers
    include ActionView::Context

    private

    def header
      content_tag :thead do
        content_tag :tr do
          I18n.t(RailsCalendar.configuration.i18n_days).each do |day|
            concat content_tag(:th, day.titleize)
          end
        end
      end
    end

    def day_cell(date)
      day_class = "#{RailsCalendar.configuration.class_prefix}#{RailsCalendar.configuration.day_number_class}"
      content_tag(:td) do
        concat content_tag(:span, date.day, class: day_class)
      end
    end
  end
end
