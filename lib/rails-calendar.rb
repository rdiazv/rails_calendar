require 'rails_calendar/simple'
require 'rails_calendar/configuration'
require 'rails_calendar/helpers'

module RailsCalendar
  if defined?(::Rails)
    class Engine < ::Rails::Engine
    end

    class Railtie < ::Rails::Railtie
      initializer 'rails-calendar.helpers' do
        ActionView::Base.send :include, Helpers
      end
    end
  end

  class << self
    attr_accessor :configuration

    def configure(&block)
      block.yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
