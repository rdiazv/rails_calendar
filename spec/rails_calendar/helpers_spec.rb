
class HelperTest
  include RailsCalendar::Helpers
end

describe RailsCalendar::Helpers do
  before do
    @helper = HelperTest.new
  end

  describe '.rails_calendar(date = Date.today, &block)' do
    it 'should return a RailsCalendar::Simple instance' do
      output = @helper.rails_calendar
      expect(output).to be_a(RailsCalendar::Simple)
    end

    it 'should pass the date to RailsCalendar' do
      date = 1.day.ago
      calendar = @helper.rails_calendar(date)
      expect(calendar.calendar_day).to be(date)
    end

    it 'should assign today as day if not specified' do
      calendar = @helper.rails_calendar
      expect(calendar.calendar_day).to eq(Date.today)
    end

    it 'should pass the helper as a view context to RailsCalendar' do
      calendar = @helper.rails_calendar
      expect(calendar.view_context).to be(@helper)
    end

    it 'should pass the block if specified' do
      callback = lambda{}
      calendar = @helper.rails_calendar(&callback)
      expect(calendar.callback).to be(callback)
    end
  end
end
