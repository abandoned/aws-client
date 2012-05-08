require 'spec_helper'

module AWS
  describe Query do
    describe '.build' do
      it 'sorts query values' do
        query = described_class.build 'q' => 1, 'p' => 2
        query.should eql 'p=2&q=1'
      end
    end

    describe '.percent_encode' do
      it 'percent-encodes reserved characters' do
        described_class.percent_encode(',').should eql '%2C'
      end

      it 'does not percent-encode unreserved characters' do
        described_class.percent_encode('~').should eql '~'
      end
    end
  end
end
