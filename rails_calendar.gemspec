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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 4.1.5"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.0.2"
  s.add_development_dependency "rspec-legacy_formatters", "~> 1.0.0"
  s.add_development_dependency "rspec-nc", "~> 0.1.1"
  s.add_development_dependency "guard", "~> 2.6.1"
  s.add_development_dependency "guard-rspec", "~> 4.3.1"
  s.add_development_dependency "coveralls", "~> 0.7.1"
end
