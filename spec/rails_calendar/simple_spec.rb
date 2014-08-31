I18n.backend.store_translations :test,
  date: {
    abbr_day_names: [
      'A', 'B', 'C', 'D', 'E', 'F', 'G'
    ]
  }

I18n.locale = :test

describe RailsCalendar::Simple, type: :feature do
  describe '#header' do
    before do
      calendar = RailsCalendar::Simple.new
      @header = calendar.send(:header)
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
end
