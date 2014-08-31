require 'action_view'

module RailsCalendar
  class Simple
    include ActionView::Helpers
    include ActionView::Context

    private

    def header
      content_tag :thead do
        content_tag :tr do
          I18n.t(RailsCalendar.configuration.i18n_days).map do |day|
            content_tag :th, day.titleize
          end.join.html_safe
        end
      end
    end
  end
end
