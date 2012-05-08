shared_examples 'an endpoint' do
  subject { described_class.new }

  describe '#key' do
    it 'requires key to have been set' do
      expect { subject.key }.to raise_error AWS::MissingKey
    end
  end

  describe '#locale' do
    it 'requires a locale to have been set' do
      expect { subject.locale }.to raise_error AWS::BadLocale
    end

    it 'requires locale to be valid' do
      subject.locale = 'foo'
      expect { subject.locale }.to raise_error AWS::BadLocale
    end
  end

  describe '#secret' do
    it 'requires secret to have been set' do
      expect { subject.secret }.to raise_error AWS::MissingSecret
    end
  end
end
