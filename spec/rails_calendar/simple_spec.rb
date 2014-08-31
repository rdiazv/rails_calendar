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

  describe '#initialize' do
    it 'should expose the global configuration through the config variable' do
      expect(@calendar.config).to be(RailsCalendar.configuration)
    end
  end

  describe '#to_s' do
    it 'should render the calendar table' do
      expect(@calendar).to receive(:table).and_return('<table></table>'.html_safe)
      expect(@calendar.to_s).to eq('<table></table>')
    end
  end

  describe '#table' do
    it 'should render a table concatenating the header and body' do
      expect(@calendar).to receive(:header).and_return('<thead></thead>'.html_safe)
      expect(@calendar).to receive(:body).and_return('<tbody></tbody>'.html_safe)

      table = @calendar.send(:table)

      expect(table).to have_selector('table > thead, table > tbody')
    end
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

  describe '#body' do
    context 'for every week' do
      it 'should render a tr with every day rendered by day_cell' do
        weeks = [
          [ Date.today, 1.day.ago, 2.days.ago ],
          [ 3.days.ago, 4.days.ago, 5.days.ago ]
        ]

        expect(@calendar).to receive(:weeks).and_return(weeks)

        weeks.each do |week|
          week.each do |date|
            expect(@calendar).to receive(:day_cell).with(date) do
              "<td>#{date.day}</td>".html_safe
            end
          end
        end

        body = @calendar.send(:body)

        expect(body).to have_selector('tbody > tr', count: 2)
        expect(body).to have_selector('tbody > tr > td', count: 6)
      end
    end
  end

  describe '#weeks' do
    it 'should return an array of dates divided by week' do
      @calendar.calendar_day = Date.strptime('2014-07-01')
      weeks = @calendar.send(:weeks)

      expect(weeks).to be_a(Array)

      weeks.each do |week|
        expect(week).to be_a(Array)
        expect(week.length).to be(7)

        week.each do |day|
          expect(day).to be_a(Date)
        end
      end
    end

    it 'should always return full weeks' do
      @calendar.calendar_day = Date.strptime('2014-07-01')
      weeks = @calendar.send(:weeks)

      expect(weeks.first.first).to eq(Date.strptime('2014-06-30'))
      expect(weeks.last.last).to eq(Date.strptime('2014-08-03'))
    end
  end

  describe '#day_cell_classes(date)' do
    before do
      RailsCalendar.configuration.class_prefix = 'rspec-'
      RailsCalendar.configuration.day_cell_class = 'test-cell'
      RailsCalendar.configuration.today_class = 'today'
    end

    it 'should have the class specified by day_cell_class config' do
      date = Date.strptime('1900-01-20')
      cell_class = @calendar.send(:day_cell_classes, date)
      expect(cell_class).to eq('rspec-test-cell')
    end

    context 'if the date is today' do
      it 'should have the class specified by today_class config' do
        date = Date.today
        cell_class = @calendar.send(:day_cell_classes, date)
        expect(cell_class).to eq('rspec-test-cell rspec-today')
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

    context 'the td' do
      it 'should assign de class returned by day_cell_classes' do
        expect(@calendar).to receive(:day_cell_classes).and_return('test-class')
        cell = @calendar.send(:day_cell, @date)
        expect(cell).to have_selector('td.test-class')
      end
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
