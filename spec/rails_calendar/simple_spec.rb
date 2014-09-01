I18n.backend.store_translations :test,
  date: {
    abbr_day_names: [
      'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
    ]
  }

I18n.locale = :test

describe RailsCalendar::Simple, type: :feature do
  before do
    @calendar = RailsCalendar::Simple.new Date.today
  end

  after do
    RailsCalendar.configuration.reset!
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

    it 'should respect the start_of_week config' do
      RailsCalendar.configuration.start_of_week = :friday
      header = @calendar.send(:header)
      expect(header).to have_selector('th:first-child', text: 'Fri')
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

    it 'should respect the start_of_week config' do
      RailsCalendar.configuration.start_of_week = :friday
      @calendar.calendar_day = Date.strptime('2014-07-01')
      weeks = @calendar.send(:weeks)
      expect(weeks.first.first).to eq(Date.strptime('2014-06-27'))
    end

    it 'should always return full weeks' do
      @calendar.calendar_day = Date.strptime('2014-07-01')
      weeks = @calendar.send(:weeks)

      expect(weeks.first.first).to eq(Date.strptime('2014-06-29'))
      expect(weeks.last.last).to eq(Date.strptime('2014-08-02'))
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
      calendar = RailsCalendar::Simple.new(date)
      cell_class = calendar.send(:day_cell_classes, date)
      expect(cell_class).to eq('rspec-test-cell')
    end

    context 'if the date is today' do
      it 'should have the class specified by today_class config' do
        date = Date.today
        cell_class = @calendar.send(:day_cell_classes, date)
        expect(cell_class).to eq('rspec-test-cell rspec-today')
      end
    end

    context 'if the date is from another month' do
      it 'should have the class specified by another_month config' do
        date = Date.today
        cell_class = @calendar.send(:day_cell_classes, date)
        expect(cell_class).to eq('rspec-test-cell rspec-today')
      end
    end
  end

  describe '#date_callback(date)' do
    context 'if the calendar has a callback' do
      before do
        @calendar.callback = Proc.new do |date|
          date == Date.today ? 'today' : 'not today'
        end
      end

      context 'if the calendar has a view context' do
        before do
          @view_context = double('view_context')
          @calendar.view_context = @view_context
        end

        it 'should capture the block with the view context' do
          expect(@view_context).to receive(:capture)
          @calendar.send(:date_callback, Date.today)
        end
      end

      context 'if the calendar noes not have a view context' do
        before do
          @calendar.view_context = nil
        end

        it 'should capture the block with the default context' do
          expect(@calendar).to receive(:capture)
          @calendar.send(:date_callback, Date.today)
        end
      end

      it 'should return the callback output' do
        output = @calendar.send(:date_callback, Date.today)
        expect(output).to eq('today')

        output = @calendar.send(:date_callback, 1.day.ago)
        expect(output).to eq('not today')
      end
    end

    context 'if the calendar does not have a callback' do
      before do
        @calendar.callback = nil
      end

      it 'should return nothing' do
        expect(@calendar.send(:date_callback, Date.today)).to_not be_present
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

    it 'should invoke date_callback passing the current date' do
      expect(@calendar).to receive(:date_callback).with(@date)
      @calendar.send(:day_cell, @date)
    end

    context 'if date_callback returns something' do
      it 'should render a div with the output' do
        allow(@calendar).to receive(:date_callback).and_return('test output')
        cell = @calendar.send(:day_cell, @date)
        expect(cell).to have_selector('td > div', text: 'test output')
      end

      context 'the div' do
        it 'should have the class specified by day_contents_class config' do
          RailsCalendar.configuration.class_prefix = 'rspec-'
          RailsCalendar.configuration.day_contents_class = 'test-day'

          allow(@calendar).to receive(:date_callback).and_return('test output')
          cell = @calendar.send(:day_cell, @date)
          expect(cell).to have_selector('td > div.rspec-test-day')
        end
      end
    end

    context 'if date_callback returns nothing' do
      it 'should not render a div' do
        allow(@calendar).to receive(:date_callback)
        cell = @calendar.send(:day_cell, @date)
        expect(cell).to_not have_selector('td > div')
      end
    end

    context 'the td' do
      it 'should assign de class returned by day_cell_classes' do
        allow(@calendar).to receive(:day_cell_classes).and_return('test-class')
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
