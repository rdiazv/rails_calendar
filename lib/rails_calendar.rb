require 'rails_calendar/simple'
require 'rails_calendar/configuration'

module RailsCalendar
  if defined?(::Rails)
    class Engine < ::Rails::Engine
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
