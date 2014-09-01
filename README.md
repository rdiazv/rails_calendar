# RailsCalendar

[![Gem Version](https://badge.fury.io/rb/rails-calendar.svg)](http://badge.fury.io/rb/rails-calendar)
[![Coverage Status](https://coveralls.io/repos/rdiazv/rails_calendar/badge.png?branch=master)](https://coveralls.io/r/rdiazv/rails_calendar?branch=master)
[![Build Status](https://travis-ci.org/rdiazv/rails_calendar.svg?branch=master)](https://travis-ci.org/rdiazv/rails_calendar)

An easy to use calendar for your rails app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-calendar'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install rails-calendar
```

## Usage

Use the provided helper to render the calendar in your view:

```erb
<%= rails_calendar %>
```

By default the calendar will show the current month, but can be easily
changed passing a Date object to the helper. For example, to render the
calendar for March 2000:

```erb
<%= rails_calendar(Date.new(2000, 3)) %>
```

Additionally, you can specify a block that will be invoked for each day to
show custom information in any calendar cell:

```erb
<%
  events = {
    '2014-03-01' => [ 'TODO 1', 'TODO 2' ],
    '2014-03-03' => [ 'TODO 3' ]
  }
%>

<%= rails_calendar(Date.new(2014, 3)) do |date| %>
  <% if events[date.to_s].present? %>
    <ul>
      <% events[date.to_s].each do |event| %>
        <li><%= event %></li>
      <% end %>
    </ul>
  <% end %>
<% end %>
```

## Contributing

1. Fork it ( https://github.com/rdiazv/rails_calendar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
