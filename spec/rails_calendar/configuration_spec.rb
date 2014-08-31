describe RailsCalendar::Configuration do
  before do
    @config = RailsCalendar::Configuration.new
    @config.class_prefix = 'test-prefix-'
  end

  describe '#to_h' do
    it 'should return all settings as a hash' do
      hash = @config.to_h
      expect(hash).to be_a(Hash)
      expect(hash.keys) =~ [
        :class_prefix, :i18n_days, :day_number_class, :day_cell_class,
        :today_class, :start_of_week
      ]
    end
  end

  describe '#get_class(name)' do
    it 'should concatenate the class prefix with the requested class' do
      @config.day_number_class = 'number-class'
      expect(@config.get_class(:day_number)).to eq('test-prefix-number-class')
    end

    context 'the name parameter' do
      it 'should end with _class optionally' do
        @config.day_number_class = 'number-class'
        class1 = @config.get_class(:day_number)
        class2 = @config.get_class(:day_number_class)
        expect(class1).to eq(class2)
      end
    end
  end
end
