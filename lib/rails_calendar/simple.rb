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
  end
end
