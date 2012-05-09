require 'spec_helper'

module AWS
  describe Query do
    describe '.percent_encode' do
      it 'percent-encodes reserved characters' do
        described_class.encode(',').should eql '%2C'
      end

      it 'does not percent-encode unreserved characters' do
        described_class.encode('~').should eql '~'
      end
    end

    describe '#clear' do
      it 'resets the query values' do
        query = described_class.new
        query.update 'p' => 1
        query.clear

        query.values.should_not have_key 'p'
      end
    end

    describe '#string' do
      it 'sorts query values' do
        query = described_class.new
        query.update 'q' => 1, 'p' => 2

        query.string.should eq 'p=2&q=1'
      end
    end

    describe '#values' do
      it 'includes default values' do
        query = described_class.new 'p' => 1
        query.values.should have_key 'p'
      end
    end
  end
end
