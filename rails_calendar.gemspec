$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_calendar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_calendar"
  s.version     = RailsCalendar::VERSION
  s.authors     = ["Rodrigo Díaz V."]
  s.email       = ["rdiazv89@gmail.com"]
  s.homepage    = "https://github.com/rdiazv/rails_calendar"
  s.summary     = "An easy to use calendar for your rails app"
  s.description = "An easy to use calendar for your rails app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.1.5"

  s.add_development_dependency "sqlite3"
end
