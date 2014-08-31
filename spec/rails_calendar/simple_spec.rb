I18n.backend.store_translations :test,
  date: {
    abbr_day_names: [
      'A', 'B', 'C', 'D', 'E', 'F', 'G'
    ]
  }

I18n.locale = :test

describe RailsCalendar::Simple, type: :feature do
  before do
    @calendar = RailsCalendar::Simple.new
  end

  describe '#header' do
    before do
      @header = @calendar.send(:header)
    end

    it 'should render a th tag for every day of the week' do
      expect(@header).to have_selector('thead > tr > th', count: 7)
    end

    it 'should set the names of the days in each th' do
      I18n.t('date.abbr_day_names').each do |day|
        expect(@header).to have_selector('th', text: day.titleize)
      end
    end
  end

  describe '#day_cell(date)' do
    before do
      @date = Date.strptime('1900-01-20')
    end

    it 'should render a td tag' do
      cell = @calendar.send(:day_cell, @date)
      expect(cell).to have_selector('td')
    end

    it 'should render a span with the day number' do
      cell = @calendar.send(:day_cell, @date)
      expect(cell).to have_selector('td > span', text: '20')
    end

    context 'the day number span' do
      it 'should have the class specified by day_number_class config' do
        RailsCalendar.configuration.class_prefix = 'rspec-'
        RailsCalendar.configuration.day_number_class = 'test-day'

        cell = @calendar.send(:day_cell, @date)
        expect(cell).to have_selector('td > span.rspec-test-day')
      end
    end
  end
end
