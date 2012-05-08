shared_examples 'an endpoint' do
  describe '.new' do
    it 'requires a valid locale' do
      expect { described_class.new('foo') }.to raise_error AWS::BadLocale
    end
  end

  context 'given an instance' do
    subject { described_class.new 'US' }

    describe '#key' do
      it 'requires key to have been set' do
        expect { subject.key }.to raise_error AWS::MissingKey
      end
    end

    describe '#secret' do
      it 'requires secret to have been set' do
        expect { subject.secret }.to raise_error AWS::MissingSecret
      end
    end
  end
end
