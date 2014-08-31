require 'action_view'

module RailsCalendar
  class Simple
    include ActionView::Helpers
    include ActionView::Context

    private

    def header
      content_tag :thead do
        content_tag :tr do
          I18n.t('date.abbr_day_names').map do |day|
            content_tag :th, day.titleize
          end.join.html_safe
        end
      end
    end
  end
end
