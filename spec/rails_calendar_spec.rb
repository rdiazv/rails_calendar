describe RailsCalendar do
  describe '.configuration' do
    it 'should be an instance of RailsCalendar::Configuration' do
      expect(RailsCalendar.configuration).to be_a(RailsCalendar::Configuration)
    end
  end

  describe '.configure' do
    it 'should expose the configuration in a block' do
      RailsCalendar.configure do |config|
        expect(config).to be(RailsCalendar.configuration)
      end
    end

    it 'should override any writen configuration' do
      RailsCalendar.configure do |config|
        config.i18n_days = 'i18n_test'
      end

      expect(RailsCalendar.configuration.i18n_days).to eq('i18n_test')
    end
  end
end
